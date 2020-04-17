import RestService

/// Request for counting records - GET /{Content-Type}/count
public class CountRequest: StrapiRequest {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	public init(contentType: String) {
		super.init(method: .get, contentType: contentType + "s", path: "/count")
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	public convenience init(contentType: ContentType) {
		self.init(contentType: contentType.rawValue)
	}
}
