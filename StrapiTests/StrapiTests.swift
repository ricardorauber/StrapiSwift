import XCTest
@testable import Strapi_iOS

class StrapiTests: XCTestCase {
	
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
}
