import RestService

/// Request for retrieving a specific record - GET /{Content-Type}/{id}
public class FetchRequest: StrapiRequest {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	public init(contentType: String, id: Int) {
		super.init(method: .get, contentType: contentType + "s", path: "/\(id)")
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	public convenience init(contentType: ContentType, id: Int) {
		self.init(contentType: contentType.rawValue, id: id)
	}
}
