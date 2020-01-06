import XCTest
@testable import Strapi

class CountRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurants"
		
		let request = CountRequest(
			contentType: contentType
		)
		
		XCTAssertEqual(request.method, "GET")
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertEqual(request.path, "/count")
		XCTAssertEqual(request.parameters.count, 0)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	// MARK: - Request
	
	func testUrlRequest() {
		let host = "localhost"
		let port = 1337
		let contentType = "restaurants"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let request = CountRequest(
			contentType: contentType
		)
		
		let task = strapi.exec(request: request, needAuthentication: false) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "GET")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)/count")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8"])
		XCTAssertNil(urlRequest!.jsonString)
	}
}
