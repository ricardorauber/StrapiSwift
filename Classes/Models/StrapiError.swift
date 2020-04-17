/// Error message received from the Strapi server
public struct StrapiError: Codable {
	
	/// Response status code
	public let statusCode: Int
	
	/// Error information
	public let error: String
	
	/// Additional error information
	public let message: String?
	
	// MARK: - Initialization
	
	/// Creates a new instance of the StrapiError
	/// - Parameters:
	///   - statusCode: Response status code
	///   - error: Error information
	///   - message: Additional error information
	public init(statusCode: Int, error: String, message: String? = nil) {
		self.statusCode = statusCode
		self.error = error
		self.message = message
	}
}
