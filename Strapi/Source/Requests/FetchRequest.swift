import Foundation

/// Request for retrieving a specific record - GET /{Content-Type}/{id}
public class FetchRequest: Request {
	
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	public init(contentType: String, id: Int) {
		super.init(method: "GET", contentType: contentType, path: "/\(id)")
	}
}
