import XCTest
@testable import Strapi

class QueryRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurants"
		let request = QueryRequest(
			contentType: contentType
		)
		XCTAssertEqual(request.method, "GET")
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertNil(request.path)
		XCTAssertEqual(request.parameters.count, 0)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
}
