import UIKit

/// Main class to send requests to the Strapi Backend
public class Strapi {
	
	// MARK: - Properties
	
	/// URLSession session
	public var session: URLSession = .shared
	
	/// HTTP scheme, could be http or https
	public var scheme: String
	
	/// Host of the service, i.e.: localhost
	public var host: String
	
	/// Port of the service, i.e.: 1337
	public var port: Int?
	
	/// Token from the authorization, it will be automatically added for requests that need authentication
	public var token: String?
	
	// MARK: - Static Properties
	
	/// Shared instance of Strapi
	public static var shared: Strapi = Strapi(scheme: "http", host: "")
	
	/// Default callback closure
	public typealias StrapiCallback = (Response) -> Void
	
	// MARK: - Initialization
	
	/// Instantiate a new object
	/// - Parameters:
	///   - scheme: HTTP scheme, could be http or https
	///   - host: Host of the service, i.e.: localhost
	///   - port: Port of the service, i.e.: 1337
	public init(scheme: String,
				host: String,
				port: Int? = nil) {
		self.scheme = scheme
		self.host = host
		self.port = port
	}
	
	// MARK: - Users
	
	/// Register a new user
	/// - Parameters:
	///   - username: User's username
	///   - email: User's email
	///   - password: User's password
	///   - callback: Completion closure
	@discardableResult
	public func register(username: String, email: String, password: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"username": username,
			"email": email,
			"password": password
		]
		let request = Request(method: Method.POST,
							  contentType: "auth",
							  path: "/local/register",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Login with the user credentials
	/// - Parameters:
	///   - identifier: Username or email
	///   - password: User's password
	///   - callback: Completion closure
	@discardableResult
	public func login(identifier: String, password: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"identifier": identifier,
			"password": password
		]
		let request = Request(method: Method.POST,
							  contentType: "auth",
							  path: "/local",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false) { response in
			if let object = response.data as? [String: Any], let token = object["jwt"] as? String {
				self.token = token
			}
			callback(response)
		}
	}
	
	/// Sends an email with a code to reset the password
	/// - Parameters:
	///   - email: Email to send the code
	///   - callback: Completion closure
	@discardableResult
	public func forgotPassword(email: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"email": email
		]
		let request = Request(method: Method.POST,
							  contentType: "auth",
							  path: "/forgot-password",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Resets a password usign a code received by email
	/// - Parameters:
	///   - code: Code received by email
	///   - password: New password
	///   - passwordConfirmation: New password confirmation
	///   - callback: Completion closure
	@discardableResult
	public func resetPassword(code: String, password: String, passwordConfirmation: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"code": code,
			"password": password,
			"passwordConfirmation": passwordConfirmation
		]
		let request = Request(method: Method.POST,
							  contentType: "auth",
							  path: "/reset-password",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Sends a new email confirmation to a given email
	/// - Parameters:
	///   - email: Email to send the confirmation
	///   - callback: Completion closure
	@discardableResult
	public func sendEmailConfirmation(email: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"email": email
		]
		let request = Request(method: Method.POST,
							  contentType: "auth",
							  path: "/send-email-confirmation",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Retrieves the logged in user
	/// - Parameters:
	///   - callback: Completion closure
	@discardableResult
	public func me(callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let request = Request(method: Method.GET,
							  contentType: "users",
							  path: "/me")
		return exec(request: request, needAuthentication: true, callback: callback)
	}
	
	// MARK: - Files
	
	/// Uploads a file to the server
	/// - Parameters:
	///   - contentType: Content type
	///   - id: Id of the record
	///   - field: Field of the content type
	///   - path: Path for AWS
	///   - filename: Name of the file
	///   - mimeType: Mime type of the file
	///   - fileData: File content as Data
	///   - needAuthentication: Flag if need the authorization token or not
	///   - callback: Completion closure
	@discardableResult
	public func upload(contentType: String,
					   id: Int,
					   field: String,
					   path: String? = nil,
					   filename: String,
					   mimeType: String,
					   fileData: Data,
					   needAuthentication: Bool,
					   callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		
		if needAuthentication && token == nil {
			return nil
		}
		
		let request = Request(
			method: Method.POST,
			contentType: "upload"
		)
		
		guard var urlRequest = urlRequest(from: request) else { return nil }
		urlRequest = addHeaders(urlRequest: urlRequest, needAuthentication: needAuthentication)
		
		let boundary = UUID().uuidString
		urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		var formData = Data()
		
		var parameters: [String: Codable] = [
			"ref": contentType,
			"refId": id,
			"field": field
		]
		if let path = path {
			parameters["path"] = path
		}
		
		for (key, value) in parameters {
			formData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
			formData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
			formData.append(String(describing: value).data(using: .utf8)!)
		}
		
		formData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
		formData.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
		formData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
		formData.append(fileData)
		
		formData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
		
		let task = session.uploadTask(with: urlRequest, from: formData) { [weak self] data, response, error in
			guard let `self` = self else { return }
			let strapiResponse = self.processResponse(data: data, response: response, error: error)
			callback(strapiResponse)
		}
		task.resume()
		return task
	}
	
	/// Uploads an image to the server
	/// - Parameters:
	///   - contentType: Content type
	///   - id: Id of the record
	///   - field: Field of the content type
	///   - path: Path for AWS
	///   - image: UIImage to be uploaded
	///   - quality: Quality of the JPG compression
	///   - needAuthentication: Flag if need the authorization token or not
	///   - callback: Completion closure
	@discardableResult
	public func upload(contentType: String,
					   id: Int,
					   field: String,
					   path: String? = nil,
					   image: UIImage,
					   compressionQuality quality: CGFloat,
					   needAuthentication: Bool,
					   callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		
		guard let fileData = image.jpegData(compressionQuality: quality) else {
			return nil
		}
		return upload(
			contentType: contentType,
			id: id,
			field: field,
			path: path,
			filename: "image.jpg",
			mimeType: "image/jpg",
			fileData: fileData,
			needAuthentication: needAuthentication,
			callback: callback
		)
	}
	
	// MARK: - Requests
	
	/// Executes a given request
	/// - Parameters:
	///   - request: Current request
	///   - needAuthentication: Flag if need the authorization token or not
	///   - autoExecute: Flag to auto execute the tsk
	///   - callback: Completion closure
	@discardableResult
	public func exec(request: Request, needAuthentication: Bool, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		if needAuthentication && token == nil {
			return nil
		}
		guard var urlRequest = urlRequest(from: request) else { return nil }
		urlRequest = addHeaders(urlRequest: urlRequest, needAuthentication: needAuthentication)
		let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
			guard let `self` = self else { return }
			let strapiResponse = self.processResponse(data: data, response: response, error: error)
			callback(strapiResponse)
		}
		task.resume()
		return task
	}
	
	/// Process the HTTP response
	/// - Parameters:
	///   - data: Received data
	///   - response: HTTP response
	///   - error: Received error
	private func processResponse(data: Data?, response: URLResponse?, error: Error?) -> Response {
		guard let httpResponse = response as? HTTPURLResponse else { return Response(code: -1) }
		var response = Response(code: httpResponse.statusCode)
		response.error = error
		if let data = data {
			if let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
				response.data = dict
			} else if let list = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
				response.data = list
			} else if let string = String(data: data, encoding: .utf8) {
				if let int = Int(string) {
					response.data = int
				} else {
					response.data = string
				}
			} else {
				response.data = data
			}
		}
		return response
	}
	
	/// Creates a URLRequest from the given request
	/// - Parameters:
	///   - request: Current request
	private func urlRequest(from request: Request) -> URLRequest? {
		var urlString = scheme + "://" + host
		if let port = port {
			urlString += ":\(port)"
		}
		urlString += "/" + request.contentType
		if let path = request.path {
			urlString += path
		}
		if request.method == Method.GET {
			urlString = makeQueryItems(urlString: urlString, request: request)
		}
		guard !request.method.isEmpty, let url = URL(string: urlString) else { return nil }
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method
		if request.method != Method.GET && request.method != Method.DELETE {
			urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.parameters, options: .prettyPrinted)
		}
		return urlRequest
	}
	
	/// Creates a string with all query items for GET requests
	/// - Parameters:
	///   - urlString: URL in string
	///   - request: Current request
	private func makeQueryItems(urlString: String, request: Request) -> String {
		var urlString = urlString + "?"
		for parameter in request.parameters {
			urlString += parameter.key + "=\(parameter.value)&"
		}
		for element in request.inNotIn {
			for parameter in element {
				urlString += parameter.key + "=\(parameter.value)&"
			}
		}
		for (index, element) in request.sortingBy.enumerated() {
			if index == 0 {
				urlString += "_sort="
			}
			for parameter in element {
				urlString += parameter.key + ":\(parameter.value),"
			}
		}
		urlString.removeLast()
		return urlString
	}
	
	/// Add all necessary headers to the request
	/// - Parameters:
	///   - urlRequest: URLRequest to manage
	///   - needAuthentication: Flag to add or not the authorization token
	private func addHeaders(urlRequest: URLRequest, needAuthentication: Bool) -> URLRequest {
		var urlRequest = urlRequest
		urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		if needAuthentication, let token = token {
			urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		return urlRequest
	}
}
