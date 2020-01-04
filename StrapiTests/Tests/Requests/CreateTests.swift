import XCTest
@testable import Strapi

class CreateTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let contentType = "restaurants"
		let parameterKey = "name"
		let parameterValue = "New Name"
		let request = Create(
			contentType: contentType,
			parameters: [parameterKey: parameterValue]
		)
		XCTAssertEqual(request.method, "POST")
		XCTAssertEqual(request.contentType, contentType)
		XCTAssertNil(request.path)
		let name = request.parameters[parameterKey] as? String
		XCTAssertEqual(name, parameterValue)
		XCTAssertEqual(request.sortingBy.count, 0)
	}
}
