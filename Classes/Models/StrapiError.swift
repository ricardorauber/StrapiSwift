/// Error message received from the Strapi server
public struct StrapiError: Codable {
	
	// MARK: - Properties
	
	/// Response status code
	public let statusCode: Int
	
	/// Error information
	public let error: String
	
	/// Original response
	public var response: Data?
	
	// MARK: - Computed properties
	
	/// A text when the "message" field is a string
	public var message: String? {
		guard let response = response, let dictionary = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers) as? [String: Any] else { return nil }
		return dictionary["message"] as? String
	}
	
	/// A list of messages when the "message" field is an array
	public var messages: [StrapiMessage] {
		var messages: [StrapiMessage] = []
		guard let response = response,
			let dictionary = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers) as? [String: Any],
			let messageGroups = dictionary["message"] as? [[String: Any]]
			else {
				return messages
		}
		for messageGroup in messageGroups {
			if let messageList = messageGroup["messages"] as? [[String: String]] {
				for messageItem in messageList {
					if let id = messageItem["id"], let message = messageItem["message"] {
						messages.append(StrapiMessage(id: id, message: message))
					}
				}
			}
		}
		return messages
	}
	
	/// The "data" field when available as a dictionary
	public var data: Any? {
		guard let response = response, let dictionary = try? JSONSerialization.jsonObject(with: response, options: .mutableContainers) as? [String: Any] else { return nil }
		return dictionary["data"]
	}
	
	// MARK: - Initialization
	
	/// Creates a new instance of the StrapiError
	/// - Parameters:
	///   - statusCode: Response status code
	///   - error: Error information
	public init(statusCode: Int, error: String) {
		self.statusCode = statusCode
		self.error = error
	}
}
