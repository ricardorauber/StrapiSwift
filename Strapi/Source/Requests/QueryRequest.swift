import Foundation

/// Request for retrieving records - GET /{Content-Type}
public class QueryRequest: Request {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	public init(contentType: String) {
		super.init(method: Method.GET, contentType: contentType + "s")
	}
}
