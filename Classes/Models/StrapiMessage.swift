/// Message received in a response from the server
public struct StrapiMessage: Codable {
	
	/// Id of the message
	public let id: String
	
	/// Text of the message
	public let message: String
	
	/// Creates a new instance of StrapiMessage
	///
	/// - Parameters:
	///   - id: Id of the message
	///   - message: Text of the message
	public init(id: String, message: String) {
		self.id = id
		self.message = message
	}
}
