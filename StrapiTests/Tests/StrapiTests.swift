import XCTest
@testable import Strapi

class StrapiTests: XCTestCase {
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Initialization
	
	func testInit() {
		let strapi = Strapi(scheme: "https", host: "localhost", port: 1337)
		XCTAssertEqual(strapi.scheme, "https")
		XCTAssertEqual(strapi.host, "localhost")
		XCTAssertEqual(strapi.port, 1337)
		XCTAssertNil(strapi.token)
	}

	func testSharedInstanceDefaultInitValues() {
		let strapi = Strapi.shared
		XCTAssertEqual(strapi.scheme, "http")
		XCTAssertEqual(strapi.host, "")
		XCTAssertNil(strapi.port)
		XCTAssertNil(strapi.token)
	}
	
	// MARK: - Edge cases
	
	func testRequestWithoutTokenNeedingAuthorization() {
		let strapi = Strapi(scheme: "https", host: "localhost", port: 1337)
		let request = QueryRequest(
			contentType: "restaurants"
		)
		let task = strapi.exec(request: request, needAuthentication: true, autoExecute: false) { _ in }
		XCTAssertNil(task)
	}
	
	func testEmptyRequest() {
		let strapi = Strapi(scheme: "", host: "")
		let request = Request(
			method: "",
			contentType: ""
		)
		let task = strapi.exec(request: request, needAuthentication: false, autoExecute: false) { _ in }
		XCTAssertNil(task)
	}
	
	func testInexistantHost() {
		let testExpectation = self.expectation(description: "Tests")
		let strapi = Strapi(scheme: "https", host: "localhost", port: 1337)
		let request = QueryRequest(
			contentType: "restaurants"
		)
		let task = strapi.exec(request: request, needAuthentication: false, autoExecute: true) { response in
			XCTAssertEqual(response.code, -1)
			XCTAssertNil(response.error)
			XCTAssertNil(response.data)
			testExpectation.fulfill()
		}
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: 3)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	func testInvalidHost() {
		let testExpectation = self.expectation(description: "Tests")
		let strapi = Strapi(scheme: "http", host: "google.com")
		let request = QueryRequest(
			contentType: "restaurants"
		)
		let task = strapi.exec(request: request, needAuthentication: false, autoExecute: true) { response in
			XCTAssertEqual(response.code, 404)
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			testExpectation.fulfill()
		}
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: 10)
		XCTAssertEqual(waiterResult, .completed)
	}
}
