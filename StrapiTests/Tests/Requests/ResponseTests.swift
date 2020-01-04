import XCTest
@testable import Strapi

class ResponseTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let code = 200
		let response = Response(code: code)
		XCTAssertEqual(response.code, code)
		XCTAssertNil(response.error)
		XCTAssertNil(response.data)
	}
	
	func testInitWithError() {
		struct DummyError: Error {}
		let code = 200
		let error = DummyError()
		let response = Response(code: code, error: error)
		XCTAssertEqual(response.code, code)
		XCTAssertNotNil(response.error)
		XCTAssertNil(response.data)
	}
	
	func testInitWithData() {
		let code = 200
		let data = "abc"
		let response = Response(code: code, data: data)
		XCTAssertEqual(response.code, code)
		XCTAssertNil(response.error)
		XCTAssertNotNil(response.data)
	}
}
