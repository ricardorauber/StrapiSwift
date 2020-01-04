import XCTest
@testable import Strapi

class RequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let method = "GET"
		let contentType = "restaurants"
		let request = Request(
			method: method,
			contentType: contentType
		)
		XCTAssertEqual(request.method, method)
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertNil(request.path)
		XCTAssertEqual(request.parameters.count, 0)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	func testFullInit() {
		let method = "GET"
		let contentType = "restaurants"
		let path = "/id"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let request = Request(
			method: method,
			contentType: contentType,
			path: path,
			parameters: [parameterKey: parameterValue]
		)
		XCTAssertEqual(request.method, method)
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertEqual(request.path, path)
		let name = request.parameters[parameterKey] as? String
		XCTAssertEqual(name, parameterValue)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	// MARK: - Parameters
	
	func testSetAndClearParameters() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.setParameter(key: parameterKey, value: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let name = request.parameters[parameterKey] as? String
		XCTAssertEqual(name, parameterValue)
		request.removeAllParameters()
		XCTAssertEqual(request.parameters.count, 0)
	}
	
	// MARK: - Filters
	
	func testSetAndClearFilters() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.setFilter(key: parameterKey, value: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let name = request.parameters[parameterKey] as? String
		XCTAssertEqual(name, parameterValue)
		request.removeAllFilters()
		XCTAssertEqual(request.parameters.count, 0)
	}
	
	func testShouldNotSetFilters() {
		let method = "POST"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.setFilter(key: parameterKey, value: parameterValue)
		XCTAssertEqual(request.parameters.count, 0)
		request.removeAllFilters()
		XCTAssertEqual(request.parameters.count, 0)
	}
	
	func testFilterEqualTo() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_eq"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, equalTo: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterNotEqualTo() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_ne"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, notEqualTo: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterLowerThan() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_lt"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, lowerThan: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterGreaterThan() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_gt"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, greaterThan: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterLowerThanOrEqualTo() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_lte"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, lowerThanOrEqualTo: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterGreaterThanOrEqualTo() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_gte"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, greaterThanOrEqualTo: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterContains() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_contains"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, contains: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterDoesntContain() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_ncontains"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, doesntContain: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterContainsCaseSensitive() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_containss"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, containsCaseSensitive: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterDoesntContainCaseSensitive() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_ncontainss"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, doesntContainCaseSensitive: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterIsNull() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = true
		let filterSuffix = "_null"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, isNull: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? Bool
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testFilterIsNotNull() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = false
		let filterSuffix = "_null"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, isNull: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[parameterKey + filterSuffix] as? Bool
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	// MARK: - In/Not In
	
	func testFilterIn() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_in"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, in: parameterValue)
		XCTAssertEqual(request.inNotIn.count, 1)
		let filter = request.inNotIn.first
		XCTAssertNotNil(filter)
		let filterValue = filter![parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filterValue)
		XCTAssertEqual(filterValue!, filterValue)
	}
	
	func testFilterNotIn() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let filterSuffix = "_nin"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, notIn: parameterValue)
		XCTAssertEqual(request.inNotIn.count, 1)
		let filter = request.inNotIn.first
		XCTAssertNotNil(filter)
		let filterValue = filter![parameterKey + filterSuffix] as? String
		XCTAssertNotNil(filterValue)
		XCTAssertEqual(filterValue!, filterValue)
	}
	
	func testShouldNotAddInNotInFilters() {
		let method = "POST"
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.filter(by: parameterKey, in: parameterValue)
		XCTAssertEqual(request.inNotIn.count, 0)
		request.filter(by: parameterKey, notIn: parameterValue)
		XCTAssertEqual(request.inNotIn.count, 0)
	}
	
	// MARK: - Limit & Start/Offset
	
	func testLimitBy() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterValue = 10
		let filterSuffix = "_limit"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.limit(by: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[filterSuffix] as? Int
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	func testStartAt() {
		let method = "GET"
		let contentType = "restaurants"
		let parameterValue = 0
		let filterSuffix = "_start"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.start(at: parameterValue)
		XCTAssertEqual(request.parameters.count, 1)
		let filter = request.parameters[filterSuffix] as? Int
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, parameterValue)
	}
	
	// MARK: - Sort
	
	func testSortingByAndClearSorting() {
		let method = "GET"
		let contentType = "restaurants"
		let sortingByKey = "name"
		let sortingByMode = "ASC"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.sort(by: sortingByKey)
		XCTAssertEqual(request.sortingBy.count, 1)
		let sortingBy = request.sortingBy.first
		XCTAssertNotNil(sortingBy)
		let filter = sortingBy![sortingByKey]
		XCTAssertNotNil(filter)
		XCTAssertEqual(filter!, sortingByMode)
		request.removeAllSortingByItems()
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	func testShouldNotSortBy() {
		let method = "POST"
		let contentType = "restaurants"
		let sortingByKey = "name"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.sort(by: sortingByKey)
		XCTAssertEqual(request.sortingBy.count, 0)
		request.removeAllSortingByItems()
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	func testSortByMultipleItems() {
		let method = "GET"
		let contentType = "restaurants"
		let sortingByKey1 = "name"
		let sortingByMode1 = "ASC"
		let sortingByKey2 = "price"
		let sortingByMode2 = "DESC"
		let request = Request(
			method: method,
			contentType: contentType
		)
		request.sort(by: sortingByKey1)
		XCTAssertEqual(request.sortingBy.count, 1)
		let sortingBy1 = request.sortingBy[0]
		XCTAssertNotNil(sortingBy1)
		let filter1 = sortingBy1[sortingByKey1]
		XCTAssertNotNil(filter1)
		XCTAssertEqual(filter1, sortingByMode1)
		request.sort(by: sortingByKey2, ascending: false)
		XCTAssertEqual(request.sortingBy.count, 2)
		let sortingBy2 = request.sortingBy[1]
		XCTAssertNotNil(sortingBy2)
		let filter2 = sortingBy2[sortingByKey2]
		XCTAssertNotNil(filter2)
		XCTAssertEqual(filter2, sortingByMode2)
	}
}
