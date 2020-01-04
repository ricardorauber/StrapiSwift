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
}
