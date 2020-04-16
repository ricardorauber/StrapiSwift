import Foundation

/// Creates a request to a Strapi service
public class Request {
	
	// MARK: - Properties
	
	/// HTTP method of the request
	public let method: String
	
	/// Strapi Content Type
	public let contentType: String
	
	/// Path of the content-type, i.e.: /count
	public let path: String?
	
	/// Query items on GET requests or Body for all other request methods
	public var parameters: [String: Codable] = [:]
	
	/// Query items for "in" and "not in" filters for GET requests
	public var inNotIn: [[String: Codable]] = []
	
	/// Ordered list for sorting the results
	public var sortingBy: [[String: String]] = []
	
	// MARK: - Initialization
	
	/// Instantiate a new object
	/// - Parameters:
	///   - method: HTTP method of the request
	///   - contentType: Strapi Content Type
	///   - path: Path of the content-type, i.e.: /count
	///   - parameters: Query items on GET requests or Body for all other request methods
	public init(method: String,
				contentType: String,
				path: String? = nil,
				parameters: [String: Codable]? = nil) {
		self.method = method.uppercased()
		self.contentType = contentType
		self.path = path
		if let parameters = parameters {
			self.parameters = parameters
		}
	}
	
	// MARK: - Parameters
	
	/// Sets a parameter by Key and Value. You should be using this only if really needed, otherwise please use Filters
	/// - Parameters:
	///   - key: Parameter key
	///   - value: Parameter Value
	public func setParameter(key: String, value: Codable) {
		parameters[key] = value
	}
	
	/// Removes all stored parameters for the request
	public func removeAllParameters() {
		parameters.removeAll()
	}
	
	// MARK: - Filters
	
	/// Sets a parameter by Key and Value for GET requests
	/// - Parameters:
	///   - key: Parameter key
	///   - value: Parameter Value
	public func setFilter(key: String, value: Codable) {
		guard method == Method.GET else { return }
		setParameter(key: key, value: value)
	}
	
	/// Removes all stored parameters for GET requests
	public func removeAllFilters() {
		guard method == Method.GET else { return }
		removeAllParameters()
	}
	
	/// Sets a "equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, equalTo value: Codable) {
		setFilter(key: field + "_eq", value: value)
	}
	
	/// Sets a "not equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, notEqualTo value: Codable) {
		setFilter(key: field + "_ne", value: value)
	}
	
	/// Sets a "lower than" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, lowerThan value: Codable) {
		setFilter(key: field + "_lt", value: value)
	}
	
	/// Sets a "greater than" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, greaterThan value: Codable) {
		setFilter(key: field + "_gt", value: value)
	}
	
	/// Sets a "lower than or equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, lowerThanOrEqualTo value: Codable) {
		setFilter(key: field + "_lte", value: value)
	}
	
	/// Sets a "greater than or equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, greaterThanOrEqualTo value: Codable) {
		setFilter(key: field + "_gte", value: value)
	}
	
	/// Sets a "contains" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, contains value: Codable) {
		setFilter(key: field + "_contains", value: value)
	}
	
	/// Sets a "doesn't contain" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, doesntContain value: Codable) {
		setFilter(key: field + "_ncontains", value: value)
	}
	
	/// Sets a case sensitive "contains" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, containsCaseSensitive value: Codable) {
		setFilter(key: field + "_containss", value: value)
	}
	
	/// Sets a case sensitive "doesn't contain" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, doesntContainCaseSensitive value: Codable) {
		setFilter(key: field + "_ncontainss", value: value)
	}
	
	/// Sets a "is null" or "is not null" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, isNull value: Bool) {
		setFilter(key: field + "_null", value: value)
	}
	
	// MARK: - In/Not In
	
	/// Sets a "in" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, in value: Codable) {
		guard method == Method.GET else { return }
		inNotIn.append([field + "_in": value])
	}
	
	/// Sets a "not in" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, notIn value: Codable) {
		guard method == Method.GET else { return }
		inNotIn.append([field + "_nin": value])
	}
	
	// MARK: - Limit & Start/Offset
	
	/// Sets a limit for a GET request
	/// - Parameters:
	///   - value: Value of the limit
	public func limit(by value: Int) {
		setFilter(key: "_limit", value: value)
	}
	
	/// Sets a starting index for a GET request
	/// - Parameters:
	///   - value: Value of the starting index
	public func start(at value: Int) {
		setFilter(key: "_start", value: value)
	}
	
	// MARK: - Sort
	
	/// Removes all sorting items of the GET request
	public func removeAllSortingByItems() {
		guard method == Method.GET else { return }
		sortingBy.removeAll()
	}
	
	/// Adds a sorting item for the GET request
	/// - Parameters:
	///   - field: Field to be sorted
	///   - ascending: Flag if ascending or descending
	public func sort(by field: String, ascending: Bool = true) {
		guard method == Method.GET else { return }
		let value = ascending ? "ASC" : "DESC"
		sortingBy.append([field: value])
	}
}
