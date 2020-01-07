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
	
	// MARK: - Users
	
	func testRegister() {
		let host = "localhost"
		let port = 1337
		let username = "username"
		let email = "email"
		let password = "password"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let task = strapi.register(
			username: username,
			email: email,
			password: password,
			callback: { _ in }
		)
		
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "POST")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/auth/local/register")
		XCTAssertNotNil(urlRequest!.jsonString)
	}
	
	func testLogin() {
		let host = "localhost"
		let port = 1337
		let identifier = "identifier"
		let password = "password"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let task = strapi.login(
			identifier: identifier,
			password: password,
			callback: { _ in }
		)
		
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "POST")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/auth/local")
		XCTAssertNotNil(urlRequest!.jsonString)
	}
	
	func testForgotPassword() {
		let host = "localhost"
		let port = 1337
		let email = "email"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let task = strapi.forgotPassword(
			email: email,
			callback: { _ in }
		)
		
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "POST")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/auth/forgot-password")
		XCTAssertNotNil(urlRequest!.jsonString)
	}
	
	func testResetPassword() {
		let host = "localhost"
		let port = 1337
		let code = "code"
		let password = "password"
		let passwordConfirmation = "passwordConfirmation"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let task = strapi.resetPassword(
			code: code,
			password: password,
			passwordConfirmation: passwordConfirmation,
			callback: { _ in }
		)
		
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "POST")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/auth/reset-password")
		XCTAssertNotNil(urlRequest!.jsonString)
	}
	
	func testSendEmailConfirmation() {
		let host = "localhost"
		let port = 1337
		let email = "email"
		let strapi = Strapi(scheme: "http", host: host, port: port)
		
		let task = strapi.sendEmailConfirmation(
			email: email,
			callback: { _ in }
		)
		
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "POST")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/auth/send-email-confirmation")
		XCTAssertNotNil(urlRequest!.jsonString)
	}
	
	func testMe() {
		let host = "localhost"
		let port = 1337
		let strapi = Strapi(scheme: "http", host: host, port: port)
		strapi.token = "abc"
		
		let task = strapi.me(
			callback: { _ in }
		)
		
		XCTAssertNotNil(task)
		let urlRequest = task?.originalRequest
		XCTAssertNotNil(urlRequest)
		XCTAssertEqual(urlRequest!.httpMethod, "GET")
		XCTAssertEqual(urlRequest!.url!.absoluteString, "http://\(host):\(port)/users/me")
		XCTAssertNil(urlRequest!.jsonString)
	}
	
	func testMeWithoutToken() {
		let host = "localhost"
		let port = 1337
		let strapi = Strapi(scheme: "http", host: host, port: port)
		let task = strapi.me(
			callback: { _ in }
		)
		XCTAssertNil(task)
	}
	
	// MARK: - Files
	
	func testFileUpload() {
		let host = "localhost"
		let port = 1337
		let strapi = Strapi(scheme: "http", host: host, port: port)
		let task = strapi.upload(
			contentType: "restaurant",
			id: 1,
			field: "photo",
			path: "path",
			filename: "filename",
			mimeType: "text",
			fileData: "test".data(using: .utf8)!,
			needAuthentication: false,
			callback: { _ in }
		)
		XCTAssertNotNil(task)
	}
	
	func testInvalidTokenFileUpload() {
		let host = "localhost"
		let port = 1337
		let strapi = Strapi(scheme: "http", host: host, port: port)
		let task = strapi.upload(
			contentType: "restaurant",
			id: 1,
			field: "photo",
			path: "path",
			filename: "filename",
			mimeType: "text",
			fileData: "test".data(using: .utf8)!,
			needAuthentication: true,
			callback: { _ in }
		)
		XCTAssertNil(task)
	}
	
	func testImageUpload() {
		let host = "localhost"
		let port = 1337
		let strapi = Strapi(scheme: "http", host: host, port: port)
		let task = strapi.upload(
			contentType: "restaurant",
			id: 1,
			field: "photo",
			path: "path",
			image: UIImage(color: .blue, size: CGSize(width: 10, height: 10)),
			compressionQuality: 90,
			needAuthentication: false,
			callback: { _ in }
		)
		XCTAssertNotNil(task)
	}
	
	func testInvalidTokenImageUpload() {
		let host = "localhost"
		let port = 1337
		let strapi = Strapi(scheme: "http", host: host, port: port)
		let task = strapi.upload(
			contentType: "restaurant",
			id: 1,
			field: "photo",
			path: "path",
			image: UIImage(color: .blue, size: CGSize(width: 10, height: 10)),
			compressionQuality: 90,
			needAuthentication: true,
			callback: { _ in }
		)
		XCTAssertNil(task)
	}
	
	// MARK: - Edge cases
	
	func testRequestWithoutTokenNeedingAuthorization() {
		let strapi = Strapi(scheme: "https", host: "localhost", port: 1337)
		let request = QueryRequest(
			contentType: "restaurant"
		)
		let task = strapi.exec(request: request, needAuthentication: true) { _ in }
		XCTAssertNil(task)
	}
	
	func testEmptyRequest() {
		let strapi = Strapi(scheme: "", host: "")
		let request = Request(
			method: "",
			contentType: ""
		)
		let task = strapi.exec(request: request, needAuthentication: false) { _ in }
		XCTAssertNil(task)
	}
	
	func testInexistantHost() {
		let testExpectation = self.expectation(description: "Tests")
		let strapi = Strapi(scheme: "https", host: "localhost", port: 1337)
		let request = QueryRequest(
			contentType: "restaurant"
		)
		let task = strapi.exec(request: request, needAuthentication: false) { response in
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
			contentType: "restaurant"
		)
		let task = strapi.exec(request: request, needAuthentication: false) { response in
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
