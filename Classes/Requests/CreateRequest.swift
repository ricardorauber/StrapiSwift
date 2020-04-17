import RestService

/// Request for creating records - POST /{Content-Type}
public class CreateRequest: StrapiRequest {
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - parameters: Body of the request
	public init(contentType: String, parameters: [String: Any]) {
		super.init(method: .post, contentType: contentType + "s", parameters: parameters)
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - contentType: Strapi Content Type
	///   - parameters: Body of the request
	public convenience init(contentType: ContentType, parameters: [String: Any]) {
		self.init(contentType: contentType.rawValue, parameters: parameters)
	}
}
