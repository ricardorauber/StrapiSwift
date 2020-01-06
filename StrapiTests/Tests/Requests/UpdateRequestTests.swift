import XCTest
@testable import Strapi

class UpdateRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurants"
		let id = 10
		let parameterKey = "name"
		let parameterValue = "New Name"
		
		let request = UpdateRequest(
			contentType: contentType,
			id: id,
			parameters: [parameterKey: parameterValue]
		)
		
		XCTAssertEqual(request.method, "PUT")
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertEqual(request.path, "/\(id)")
		XCTAssertEqual(request.parameters.count, 1)
		let name = request.parameters[parameterKey] as? String
		XCTAssertEqual(name, parameterValue)
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
		let parameterKey = "name"
		let parameterValue = "New Name"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		strapi.token = token
		
		let request = UpdateRequest(
			contentType: contentType,
			id: id,
			parameters: [parameterKey: parameterValue]
		)
		
		let task = strapi.exec(request: request, needAuthentication: true, autoExecute: false) { _ in }
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "PUT")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/\(contentType)/\(id)")
		XCTAssertEqual(urlRequest!.allHTTPHeaderFields, ["Content-Type": "application/json; charset=utf-8", "Authorization": "Bearer abcde"])
		XCTAssertEqual(urlRequest!.jsonString, "[\"\(parameterKey)\": \(parameterValue)]")
	}
}
