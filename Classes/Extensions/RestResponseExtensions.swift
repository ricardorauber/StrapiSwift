import RestService

public extension RestResponse {
	
	/// Converts the data into a Strapi default error message
	func strapiError() -> StrapiError? {
		var error = decodableValue(of: StrapiError.self)
		error?.response = data
		return error
	}
}
