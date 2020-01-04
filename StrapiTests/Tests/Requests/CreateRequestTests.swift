import XCTest
@testable import Strapi

class CreateRequestTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let request = CreateRequest(
			contentType: contentType,
			parameters: [parameterKey: parameterValue]
		)
		XCTAssertEqual(request.method, "POST")
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertNil(request.path)
		XCTAssertEqual(request.parameters.count, 1)
		let name = request.parameters[parameterKey] as? String
		XCTAssertEqual(name, parameterValue)
		XCTAssertEqual(request.inNotIn.count, 0)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
}
