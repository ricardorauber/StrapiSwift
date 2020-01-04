import XCTest
@testable import Strapi

class FetchRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurants"
		let id = 10
		let request = FetchRequest(
			contentType: contentType,
			id: id
		)
		XCTAssertEqual(request.method, "GET")
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertEqual(request.path, "/\(id)")
		XCTAssertEqual(request.parameters.count, 0)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
}
