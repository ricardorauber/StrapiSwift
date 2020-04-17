import RestService

public extension RestResponse {
	
	/// Converts the data into a Strapi default error message
	func strapiError() -> StrapiError? {
		return decodableValue(of: StrapiError.self)
	}
}
