import RestService

/// Request for destroying a specific record - DELETE /{Content-Type}/{id}
public class DestroyRequest: StrapiRequest {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	public init(contentType: String, id: Int) {
		super.init(method: .delete, contentType: contentType + "s", path: "/\(id)")
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	public convenience init(contentType: ContentType, id: Int) {
		self.init(contentType: contentType.rawValue, id: id)
	}
}
