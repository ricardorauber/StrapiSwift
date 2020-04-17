import RestService

/// Request for retrieving records - GET /{Content-Type}
public class QueryRequest: StrapiRequest {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	public init(contentType: String) {
		super.init(method: .get, contentType: contentType + "s")
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	public convenience init(contentType: ContentType) {
		self.init(contentType: contentType.rawValue)
	}
}
