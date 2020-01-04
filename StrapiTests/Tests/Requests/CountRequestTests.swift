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
}
