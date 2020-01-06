import XCTest
@testable import Strapi

class DestroyRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurants"
		let id = 10
		
		let request = DestroyRequest(
			contentType: contentType,
			id: id
		)
		
		XCTAssertEqual(request.method, "DELETE")
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertEqual(request.path, "/\(id)")
		XCTAssertEqual(request.parameters.count, 0)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
	
	// MARK: - Request
	
	func testUrlRequest() {
		let host = "localhost"
		let port = 1337
		let token = "abcde"
		let contentType = "restaurants"
		let id = 10
		let strapi = Strapi(scheme: "http", host: host, port: port)
		strapi.token = token
		
		let request = DestroyRequest(
			contentType: contentType,
			id: id
		)
		
		let task = strapi.exec(request: request, needAuthentication: true) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "DELETE")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)/\(id)")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer abcde"])
		XCTAssertNil(urlRequest!.jsonString)
	}
}
