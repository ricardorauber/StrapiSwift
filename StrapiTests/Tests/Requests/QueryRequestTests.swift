import XCTest
@testable import Strapi

class QueryRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurant"
		
		let request = QueryRequest(
			contentType: contentType
		)
		
		XCTAssertEqual(request.method, "GET")
		XCTAssertEqual(request.contentType, contentType + "s")
		XCTAssertNil(request.path)
		XCTAssertEqual(request.parameters.count, 0)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	// MARK: - Request
	
	func testUrlRequest() {
		let host = "localhost"
		let port = 1337
		let contentType = "restaurant"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let request = QueryRequest(
			contentType: contentType
		)
		
		let task = strapi.exec(request: request, needAuthentication: false) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "GET")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)s")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8"])
		XCTAssertNil(urlRequest!.jsonString)
	}
	
	func testUrlRequestWithFilter() {
		let host = "localhost"
		let port = 1337
		let contentType = "restaurant"
		let filterKey = "name"
		let filterValue = "pizza"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let request = QueryRequest(
			contentType: contentType
		)
		request.filter(by: filterKey, contains: filterValue)
		
		let task = strapi.exec(request: request, needAuthentication: false) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "GET")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)s?\(filterKey)_contains=\(filterValue)")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8"])
		XCTAssertNil(urlRequest!.jsonString)
	}
	
	func testUrlRequestWithInFilter() {
		let host = "localhost"
		let port = 1337
		let contentType = "restaurant"
		let filterKey = "name"
		let filterValue = "pizza"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let request = QueryRequest(
			contentType: contentType
		)
		request.filter(by: filterKey, in: filterValue)
		
		let task = strapi.exec(request: request, needAuthentication: false) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "GET")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)s?\(filterKey)_in=\(filterValue)")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8"])
		XCTAssertNil(urlRequest!.jsonString)
	}
	
	func testUrlRequestWithSorting() {
		let host = "localhost"
		let port = 1337
		let contentType = "restaurant"
		let sortingKey = "name"
		let sortingValue = "ASC"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let request = QueryRequest(
			contentType: contentType
		)
		request.sort(by: sortingKey)
		
		let task = strapi.exec(request: request, needAuthentication: false) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "GET")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)s?_sort=\(sortingKey):\(sortingValue)")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8"])
		XCTAssertNil(urlRequest!.jsonString)
	}
}
