import Foundation

/// Request for updating a specific record - PUT /{Content-Type}/{id}
public class UpdateRequest: Request {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	///   - parameters: Body of the request
	public init(contentType: String, id: Int, parameters: [String: Codable]) {
		super.init(method: "PUT", contentType: contentType, path: "/\(id)", parameters: parameters)
	}
}
