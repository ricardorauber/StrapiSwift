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
}
