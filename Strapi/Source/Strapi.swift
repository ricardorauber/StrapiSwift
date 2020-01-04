import Foundation

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
	
	public static var shared: Strapi = Strapi(scheme: "http", host: "")
	
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
	public func register(username: String, email: String, password: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"username": username,
			"email": email,
			"password": password
		]
		let request = Request(method: "POST",
							  contentType: "auth",
							  path: "/local/register",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Login with the user credentials
	/// - Parameters:
	///   - identifier: Username or email
	///   - password: User's password
	public func login(identifier: String, password: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"identifier": identifier,
			"password": password
		]
		let request = Request(method: "POST",
							  contentType: "auth",
							  path: "/local",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Sends an email with a code to reset the password
	/// - Parameters:
	///   - email: Email to send the code
	public func forgotPassword(email: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"email": email
		]
		let request = Request(method: "POST",
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
	public func resetPassword(code: String, password: String, passwordConfirmation: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"code": code,
			"password": password,
			"passwordConfirmation": passwordConfirmation
		]
		let request = Request(method: "POST",
							  contentType: "auth",
							  path: "/reset-password",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Sends a new email confirmation to a given email
	/// - Parameters:
	///   - email: Email to send the confirmation
	public func sendEmailConfirmation(email: String, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let parameters: [String: Codable] = [
			"email": email
		]
		let request = Request(method: "POST",
							  contentType: "auth",
							  path: "/send-email-confirmation",
							  parameters: parameters)
		return exec(request: request, needAuthentication: false, callback: callback)
	}
	
	/// Retrieves the logged in user
	public func me(callback: @escaping StrapiCallback) -> URLSessionDataTask? {
		let request = Request(method: "GET",
							  contentType: "users",
							  path: "/me")
		return exec(request: request, needAuthentication: true, callback: callback)
	}
	
	// MARK: - Requests
	
	/// Executes a given request
	/// - Parameters:
	///   - request: Current request
	///   - needAuthentication: Flag if need the authorization token or not
	///   - autoExecute: Flag to auto execute the tsk
	@discardableResult
	public func exec(request: Request, needAuthentication: Bool, autoExecute: Bool = true, callback: @escaping StrapiCallback) -> URLSessionDataTask? {
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
		if autoExecute {
			task.resume()
		}
		return task
	}
	
	private func processResponse(data: Data?, response: URLResponse?, error: Error?) -> Response {
		guard let httpResponse = response as? HTTPURLResponse else { return Response(code: -1) }
		var response = Response(code: httpResponse.statusCode)
		response.error = error
		if let data = data {
			if let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
				response.data = dict
			} else if let list = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
				response.data = list
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
		if request.method == "GET" {
			urlString = makeQueryItems(urlString: urlString, request: request)
		}
		guard !request.method.isEmpty, let url = URL(string: urlString) else { return nil }
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method
		if request.method != "GET" && request.method != "DELETE" {
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
