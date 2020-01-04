import Foundation

/// Request for retrieving a specific record - GET /{Content-Type}/{id}
public class FetchRequest: Request {
	
	/// Instantiate a new object
	/// - Parameter contentType: Strapi Content Type
	/// - Parameter id: ID of the record
	public init(contentType: String, id: Int) {
		super.init(method: "GET", contentType: contentType, path: "/\(id)")
	}
}
