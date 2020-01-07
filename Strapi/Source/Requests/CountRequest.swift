import Foundation

/// Request for counting records - GET /{Content-Type}/count
public class CountRequest: Request {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	public init(contentType: String) {
		super.init(method: Method.GET, contentType: contentType + "s", path: "/count")
	}
}
