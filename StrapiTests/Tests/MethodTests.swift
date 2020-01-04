import XCTest
@testable import Strapi

class MethodTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	func testPost() {
		let method = Method.POST
		XCTAssertEqual(method, "POST")
	}
	
	func testGet() {
		let method = Method.GET
		XCTAssertEqual(method, "GET")
	}
	
	func testPut() {
		let method = Method.PUT
		XCTAssertEqual(method, "PUT")
	}
	
	func testDelete() {
		let method = Method.DELETE
		XCTAssertEqual(method, "DELETE")
	}
}
