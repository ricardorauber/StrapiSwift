import Foundation

/// Main class to send requests to the Strapi Backend
public class Strapi {
	
	// MARK: - Properties
	
	/// HTTP scheme, could be http or https
	public var scheme: String
	
	/// Host of the service, i.e.: localhost
	public var host: String
	
	/// Port of the service, i.e.: 1337
	public var port: Int?
	
	/// Token from the authorization, it will be automatically added for requests that need authentication
	public var token: String?
	
	// MARK: - Static Properties
	
	public static var shared: Strapi = Strapi(scheme: "http", host: "", port: nil)
	
	// MARK: - Initialization
	
	/// Instantiate a new object
	/// - Parameters:
	///   - scheme: HTTP scheme, could be http or https
	///   - host: Host of the service, i.e.: localhost
	///   - port: Port of the service, i.e.: 1337
	public init(scheme: String,
				host: String,
				port: Int?) {
		self.scheme = scheme
		self.host = host
		self.port = port
	}
}
