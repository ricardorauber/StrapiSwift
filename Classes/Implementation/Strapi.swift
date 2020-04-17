import KeyValueStorage
import RestService
import UIKit

/// Make requests to a Strapi Backend
public class Strapi {
	
	/// Shared Strapi instance, the Host should be set before usage
	public static var shared = Strapi(host: "")
	
	// MARK: - Properties
	
	/// Key-Value storage
	public var storage: KeyValueStorage
	
	/// Rest service
	public var service: RestService {
		didSet {
			service.resumeTasksAutomatically = false
		}
	}
	
	/// HTTP scheme
	public var scheme: HTTPScheme {
		set {
			service.scheme = newValue
		}
		get {
			return service.scheme
		}
	}
	
	/// Host of the service, i.e.: localhost
	public var host: String {
		set {
			service.host = newValue
		}
		get {
			return service.host
		}
	}
	
	/// Port of the service, i.e.: 1337
	public var port: Int? {
		set {
			service.port = newValue
		}
		get {
			return service.port
		}
	}
	
	// MARK: - Initialization
	
	/// Creates a new instance of Strapi
	///
	/// - Parameters:
	///   - storage: Key-Value storage
	///   - service: Rest service
	public init(storage: KeyValueStorage, service: RestService) {
		self.storage = storage
		self.service = service
		service.resumeTasksAutomatically = false
	}
	
	/// Creates a new instance of Strapi
	///
	/// - Parameters:
	///   - storage: Key-Value storage
	///   - session: URLSession
	///   - scheme: HTTP scheme
	///   - host: Host of the service, i.e.: localhost
	///   - port: Port of the service, i.e.: 1337
	public convenience init(storage: KeyValueStorage = KeychainKeyValueStorage(),
							session: URLSession = .shared,
							scheme: HTTPScheme = .https,
							host: String,
							port: Int? = nil) {

		let service = RestService(session: session, scheme: scheme, host: host, port: port)
		self.init(storage: storage, service: service)
	}
	
	// MARK: - Users
	
	/// Register a new user
	///
	/// - Parameters:
	///   - username: User's username
	///   - email: User's email
	///   - password: User's password
	///   - callback: Completion closure
	@discardableResult
	public func register(username: String,
						 email: String,
						 password: String,
						 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let parameters: [String: Any] = [
			"username": username,
			"email": email,
			"password": password
		]
		let request = StrapiRequest(method: .post,
							  contentType: "auth",
							  path: "/local/register",
							  parameters: parameters)
		return exec(request: request, callback: callback)
	}
	
	/// Login with the user credentials
	///
	/// - Parameters:
	///   - identifier: Username or email
	///   - password: User's password
	///   - callback: Completion closure
	@discardableResult
	public func login(identifier: String,
					  password: String,
					  callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let parameters: [String: Any] = [
			"identifier": identifier,
			"password": password
		]
		let request = StrapiRequest(method: .post,
							  contentType: "auth",
							  path: "/local",
							  parameters: parameters)
		return exec(request: request) { [weak self] response in
			if let object = response.dictionaryValue(), let token = object["jwt"] as? String {
				self?.storage.set(string: token, for: .strapiAuthorizationKey)
			}
			callback(response)
		}
	}
	
	/// Sends an email with a code to reset the password
	///
	/// - Parameters:
	///   - email: Email to send the code
	///   - callback: Completion closure
	@discardableResult
	public func forgotPassword(email: String,
							   callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let parameters: [String: Any] = [
			"email": email
		]
		let request = StrapiRequest(method: .post,
							  contentType: "auth",
							  path: "/forgot-password",
							  parameters: parameters)
		return exec(request: request, callback: callback)
	}
	
	/// Resets a password usign a code received by email
	///
	/// - Parameters:
	///   - code: Code received by email
	///   - password: New password
	///   - passwordConfirmation: New password confirmation
	///   - callback: Completion closure
	@discardableResult
	public func resetPassword(code: String,
							  password: String,
							  passwordConfirmation: String,
							  callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let parameters: [String: Any] = [
			"code": code,
			"password": password,
			"passwordConfirmation": passwordConfirmation
		]
		let request = StrapiRequest(method: .post,
							  contentType: "auth",
							  path: "/reset-password",
							  parameters: parameters)
		return exec(request: request, callback: callback)
	}
	
	/// Sends a new email confirmation to a given email
	///
	/// - Parameters:
	///   - email: Email to send the confirmation
	///   - callback: Completion closure
	@discardableResult
	public func sendEmailConfirmation(email: String,
									  callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let parameters: [String: Any] = [
			"email": email
		]
		let request = StrapiRequest(method: .post,
							  contentType: "auth",
							  path: "/send-email-confirmation",
							  parameters: parameters)
		return exec(request: request, callback: callback)
	}
	
	/// Retrieves the logged in user
	///
	/// - Parameters:
	///   - callback: Completion closure
	@discardableResult
	public func me(callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let request = StrapiRequest(method: .get,
							  contentType: "users",
							  path: "/me")
		let interceptor = StrapiAuthorizationInterceptor(storage: storage)
		return exec(request: request, interceptor: interceptor, callback: callback)
	}
	
	// MARK: - Files
	
	/// Uploads a file to the server
	/// - Parameters:
	///   - contentType: Content type
	///   - id: Id of the record
	///   - field: Field of the content type
	///   - source: Plugin name
	///   - path: Path for AWS
	///   - filename: Name of the file
	///   - mimeType: Mime type of the file
	///   - fileData: File content as Data
	///   - interceptor: Adapts the request after creation
	///   - autoExecute: Flag to automatically execute the tsk
	///   - callback: Completion closure
	@discardableResult
	public func upload(contentType: String,
					   id: Int,
					   field: String,
					   source: String? = nil,
					   path: String? = nil,
					   filename: String,
					   mimeType: String,
					   fileData: Data,
					   interceptor: RestRequestInterceptor? = nil,
					   autoExecute: Bool = true,
					   callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		var parameters: [FormDataParameter] = [
			TextFormDataParameter(name: "ref", value: contentType),
			TextFormDataParameter(name: "refId", value: "\(id)"),
			TextFormDataParameter(name: "field", value: field)
		]
		if let source = source {
			parameters.append(TextFormDataParameter(name: "source", value: source))
		}
		if let path = path {
			parameters.append(TextFormDataParameter(name: "path", value: path))
		}
		parameters.append(FileFormDataParameter(name: "files", filename: filename, contentType: mimeType, data: fileData))
		
		let task = service.formData(
			method: .post,
			path: "/upload",
			parameters: parameters,
			interceptor: interceptor,
			callback: callback)
		if autoExecute {
			task?.resume()
		}
		return task
	}
	
	/// Uploads an image to the server
	/// - Parameters:
	///   - contentType: Content type
	///   - id: Id of the record
	///   - field: Field of the content type
	///   - source: Source
	///   - path: Path for AWS
	///   - filename: Name of the file
	///   - mimeType: Mime type of the file
	///   - image: UIImage to be uploaded
	///   - quality: Quality of the JPG compression
	///   - interceptor: Adapts the request after creation
	///   - autoExecute: Flag to automatically execute the tsk
	///   - callback: Completion closure
	@discardableResult
	public func upload(contentType: String,
					   id: Int,
					   field: String,
					   source: String? = nil,
					   path: String? = nil,
					   filename: String = "image.jpg",
					   mimeType: String = "image/jpg",
					   image: UIImage,
					   compressionQuality quality: CGFloat,
					   interceptor: RestRequestInterceptor? = nil,
					   autoExecute: Bool = true,
					   callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		guard let fileData = image.jpegData(compressionQuality: quality) else {
			return nil
		}
		return upload(
			contentType: contentType,
			id: id,
			field: field,
			source: source,
			path: path,
			filename: filename,
			mimeType: mimeType,
			fileData: fileData,
			interceptor: interceptor,
			autoExecute: autoExecute,
			callback: callback
		)
	}
	
	// MARK: - Requests
	
	/// Executes a given request
	/// - Parameters:
	///   - request: Current request
	///   - interceptor: Adapts the request after creation
	///   - autoExecute: Flag to automatically execute the tsk
	///   - callback: Completion closure
	@discardableResult
	public func exec(request: StrapiRequest,
					 interceptor: RestRequestInterceptor? = nil,
					 autoExecute: Bool = true,
					 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let path = "/" + request.contentType + (request.path ?? "")
		let task = service.json(method: request.method,
								path: path,
								parameters: request.parameters,
								interceptor: interceptor,
								callback: callback)
		if autoExecute {
			task?.resume()
		}
		return task
	}
}
