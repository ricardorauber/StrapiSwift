import RestService

/// Creates a request to a Strapi service
public class StrapiRequest {
	
	// MARK: - Properties
	
	/// HTTP method of the request
	public var method: HTTPMethod
	
	/// Strapi Content Type
	public var contentType: String
	
	/// Path of the content-type, i.e.: /count
	public var path: String?
	
	/// Query items on GET requests or Body for all other request methods
	public var parameters: [String: Any]
	
	/// Check if the request can use filters. They are only allowed for query requests (GET, HEAD, DELETE)
	public var canSetFilters: Bool {
		return method == .get || method == .delete || method == .head
	}
	
	// MARK: - Initialization
	
	/// Instantiate a new object
	/// - Parameters:
	///   - method: HTTP method of the request
	///   - contentType: Strapi Content Type
	///   - path: Path of the content-type, i.e.: /count
	///   - parameters: Query items on GET requests or Body for all other request methods
	public init(method: HTTPMethod,
				contentType: String,
				path: String? = nil,
				parameters: [String: Any]? = nil) {

		self.method = method
		self.contentType = contentType
		self.path = path
		self.parameters = parameters ?? [:]
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - method: HTTP method of the request
	///   - contentType: Strapi Content Type
	///   - path: Path of the content-type, i.e.: /count
	///   - parameters: Query items on GET requests or Body for all other request methods
	public init(method: HTTPMethod,
				contentType: ContentType,
				path: String? = nil,
				parameters: [String: Any]? = nil) {

		self.method = method
		self.contentType = contentType.rawValue
		self.path = path
		self.parameters = parameters ?? [:]
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - method: HTTP method of the request
	///   - contentType: Strapi Content Type
	///   - path: Path of the content-type
	///   - parameters: Query items on GET requests or Body for all other request methods
	public init(method: HTTPMethod,
				contentType: String,
				path: [RestPath],
				parameters: [String: Any]? = nil) {

		self.method = method
		self.contentType = contentType
		self.parameters = parameters ?? [:]
		self.path = buildPath(path)
	}
	
	/// Instantiate a new object
	/// - Parameters:
	///   - method: HTTP method of the request
	///   - contentType: Strapi Content Type
	///   - path: Path of the content-type, i.e.: /count
	///   - parameters: Query items on GET requests or Body for all other request methods
	public init(method: HTTPMethod,
				contentType: ContentType,
				path: [RestPath],
				parameters: [String: Any]? = nil) {

		self.method = method
		self.contentType = contentType.rawValue
		self.parameters = parameters ?? [:]
		self.path = buildPath(path)
	}
	
	// MARK: - Builders
	
	/// Builds the path from a list of RestPath
	///
	/// - Parameters:
	///   - path: List of RestPath
	func buildPath(_ path: [RestPath]) -> String {
		let stringPaths = path.map { $0.rawValue }
		let fullPath = "/" + stringPaths.joined(separator: "/")
		return fullPath
	}
	
	// MARK: - Parameters
	
	/// Sets a parameter by Key and Value. You should be using this only if really needed, otherwise please use Filters
	/// - Parameters:
	///   - key: Parameter key
	///   - value: Parameter Value
	public func setParameter(key: String, value: Any) {
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
	public func setFilter(key: String, value: Any) {
		guard canSetFilters else { return }
		setParameter(key: key, value: value)
	}
	
	/// Removes all stored parameters for GET requests
	public func removeAllFilters() {
		guard canSetFilters else { return }
		removeAllParameters()
	}
	
	/// Sets a "equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, equalTo value: Any) {
		setFilter(key: field + "_eq", value: value)
	}
	
	/// Sets a "not equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, notEqualTo value: Any) {
		setFilter(key: field + "_ne", value: value)
	}
	
	/// Sets a "lower than" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, lowerThan value: Any) {
		setFilter(key: field + "_lt", value: value)
	}
	
	/// Sets a "greater than" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, greaterThan value: Any) {
		setFilter(key: field + "_gt", value: value)
	}
	
	/// Sets a "lower than or equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, lowerThanOrEqualTo value: Any) {
		setFilter(key: field + "_lte", value: value)
	}
	
	/// Sets a "greater than or equal to" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, greaterThanOrEqualTo value: Any) {
		setFilter(key: field + "_gte", value: value)
	}
	
	/// Sets a "contains" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, contains value: Any) {
		setFilter(key: field + "_contains", value: value)
	}
	
	/// Sets a "doesn't contain" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, doesntContain value: Any) {
		setFilter(key: field + "_ncontains", value: value)
	}
	
	/// Sets a case sensitive "contains" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, containsCaseSensitive value: Any) {
		setFilter(key: field + "_containss", value: value)
	}
	
	/// Sets a case sensitive "doesn't contain" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, doesntContainCaseSensitive value: Any) {
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
	public func filter(by field: String, in value: Any) {
		guard canSetFilters else { return }
		let fieldName = field + "_in"
		var list: [Any] = parameters[fieldName] as? [Any] ?? []
		list.append(value)
		parameters[fieldName] = list
	}
	
	/// Sets a "not in" filter for a GET request
	/// - Parameters:
	///   - field: Field to be filtered
	///   - value: Value of the field
	public func filter(by field: String, notIn value: Any) {
		guard canSetFilters else { return }
		let fieldName = field + "_nin"
		var list: [Any] = parameters[fieldName] as? [Any] ?? []
		list.append(value)
		parameters[fieldName] = list
	}
	
	// MARK: - Response Settings
	
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
		guard canSetFilters else { return }
		parameters["_sort"] = nil
	}
	
	/// Adds a sorting item for the GET request
	/// - Parameters:
	///   - field: Field to be sorted
	///   - ascending: Flag if ascending or descending
	public func sort(by field: String, ascending: Bool = true) {
		guard canSetFilters else { return }
		let value = ascending ? "ASC" : "DESC"
		var sortingBy = parameters["_sort"] as? String ?? ""
		if sortingBy.count > 0 {
			sortingBy += ","
		}
		sortingBy += field + ":" + value
		parameters["_sort"] = sortingBy
	}
}
