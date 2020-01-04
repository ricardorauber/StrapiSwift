import Foundation

/// Request for creating records - POST /{Content-Type}
public class CreateRequest: Request {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - parameters: Body of the request
	public init(contentType: String, parameters: [String: Codable]) {
		super.init(method: "POST", contentType: contentType, parameters: parameters)
	}
}
