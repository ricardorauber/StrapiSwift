import Foundation

/// Request for counting records - GET /{Content-Type}/count
public class CountRequest: Request {
	
	/// Instantiate a new object
	/// - Parameter contentType: Strapi Content Type
	public init(contentType: String) {
		super.init(method: "GET", contentType: contentType, path: "/count")
	}
}
