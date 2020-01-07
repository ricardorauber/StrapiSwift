import Foundation

/// Request for retrieving a specific record - GET /{Content-Type}/{id}
public class FetchRequest: Request {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	public init(contentType: String, id: Int) {
		super.init(method: Method.GET, contentType: contentType + "s", path: "/\(id)")
	}
}
