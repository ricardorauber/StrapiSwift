import Foundation

/// Response from the requests
public struct Response {
	
	/// HTTP status code
	var code: Int
	
	/// Error if happened
	var error: Error?
	
	/// Response data
	var data: Any?
	
	/// Instantiate a new object
	/// - Parameters:
	///   - code: HTTP status code
	///   - error: Error if happened
	///   - data: Response data
	public init(code: Int,
				error: Error? = nil,
				data: Any? = nil) {
		self.code = code
		self.error = error
		self.data = data
	}
}
