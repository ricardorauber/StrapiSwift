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
	
	// MARK: - Requests
	
	@discardableResult
	public func exec(request: Request, needAuthentication: Bool, autoExecute: Bool = true) -> URLSessionDataTask? {
		if needAuthentication && token == nil {
			return nil
		}
		guard var urlRequest = urlRequest(from: request) else { return nil }
		urlRequest = addHeaders(urlRequest: urlRequest, needAuthentication: needAuthentication)
		let task = session.dataTask(with: urlRequest)
		return task
	}
	
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
	
	private func addHeaders(urlRequest: URLRequest, needAuthentication: Bool) -> URLRequest {
		var urlRequest = urlRequest
		urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		if needAuthentication, let token = token {
			urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		return urlRequest
	}
}
