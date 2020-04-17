import RestService

/// Request for updating a specific record - PUT /{Content-Type}/{id}
public class UpdateRequest: StrapiRequest {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	///   - parameters: Body of the request
	public init(contentType: String, id: Int, parameters: [String: Any]) {
		super.init(method: .put, contentType: contentType + "s", path: "/\(id)", parameters: parameters)
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - id: ID of the record
	///   - parameters: Body of the request
	public convenience init(contentType: ContentType, id: Int, parameters: [String: Any]) {
		self.init(contentType: contentType.rawValue, id: id, parameters: parameters)
	}
}
