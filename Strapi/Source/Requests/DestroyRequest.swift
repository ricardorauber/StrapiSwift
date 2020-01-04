import Foundation

/// Request for destroying a specific record - DELETE /{Content-Type}/{id}
public class DestroyRequest: Request {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	public init(contentType: String, id: Int) {
		super.init(method: Method.DELETE, contentType: contentType, path: "/\(id)")
	}
}
