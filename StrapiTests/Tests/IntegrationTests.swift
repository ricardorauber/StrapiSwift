import XCTest
@testable import Strapi

class IntegrationTests: XCTestCase {
	
	// MARK: - Settings
	
	let contentType = "restaurants"
	let strapi = Strapi(scheme: "https", host: "strapi-ios.herokuapp.com")
	let timeout: TimeInterval = 2
	
	override func setUp() {
		continueAfterFailure = false
	}
	
	// MARK: - Tests
	
	func testIntegration() {
		
		// User
		let username = String(describing: Date().timeIntervalSince1970)
		let email = username + "@admin.com"
		let password = "password"
		register(username: username, email: email, password: password)
		login(identifier: email, password: password)
		let userId = me()
		
		// Content Type
		let restaurantName = "Ricardo's Pizza"
		var restaurantPrice = 3
		let restaurantId = createRestaurant(name: restaurantName, price: restaurantPrice)
		countRestaurants()
		queryRestaurants(price: restaurantPrice)
		fetchRestaurant(id: restaurantId, name: restaurantName, price: restaurantPrice)
		restaurantPrice = 5
		updateRestaurant(id: restaurantId, price: restaurantPrice)
		fetchRestaurant(id: restaurantId, name: restaurantName, price: restaurantPrice)
		destroyRestaurant(id: restaurantId)
		
		destroyUser(id: userId)
	}
	
	// MARK: - User Steps
	
	func register(username: String, email: String, password: String) {
		let testExpectation = self.expectation(description: "Tests")
		
		let task = strapi.register(username: username, email: email, password: password) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let object = response.data as? [String: Any],
				let user = object["user"] as? [String: Any]
				else {
					XCTFail("Could not serialize the response")
					return
			}
			let id = user["id"] as? Int
			XCTAssertNotNil(id)
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	func login(identifier: String, password: String) {
		let testExpectation = self.expectation(description: "Tests")
		
		let task = strapi.login(identifier: identifier, password: password) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let object = response.data as? [String: Any] else {
				XCTFail("Could not serialize the response")
				return
			}
			let token = object["jwt"] as? String
			XCTAssertNotNil(token)
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	func me() -> Int {
		let testExpectation = self.expectation(description: "Tests")
		var id: Int?
		
		let task = strapi.me() { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let user = response.data as? [String: Any] else {
				XCTFail("Could not serialize the response")
				return
			}
			id = user["id"] as? Int
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
		XCTAssertNotNil(id)
		return id!
	}
	
	func destroyUser(id: Int) {
		let testExpectation = self.expectation(description: "Tests")
		
		let request = DestroyRequest(
			contentType: "users",
			id: id
		)
		
		let task = strapi.exec(request: request, needAuthentication: true) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let object = response.data as? [String: Any],
				let destroyedId = object["id"] as? Int
				else {
					XCTFail("Could not serialize the response")
					return
			}
			XCTAssertEqual(destroyedId, id)
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	// MARK: - Content Type Steps
	
	func createRestaurant(name: String, price: Int) -> Int {
		let testExpectation = self.expectation(description: "Tests")
		var id: Int?
		
		let request = CreateRequest(
			contentType: contentType,
			parameters: [
				"name": name,
				"price": price
			]
		)
		
		let task = strapi.exec(request: request, needAuthentication: true) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let object = response.data as? [String: Any] else {
				XCTFail("Could not serialize the response")
				return
			}
			id = object["id"] as? Int
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
		XCTAssertNotNil(id)
		return id!
	}
	
	func countRestaurants() {
		let testExpectation = self.expectation(description: "Tests")
		let request = CountRequest(contentType: contentType)
		let task = strapi.exec(request: request, needAuthentication: true) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let count = response.data as? Int else {
				XCTFail("Could not serialize the response")
				return
			}
			XCTAssertGreaterThan(count, 0)
			testExpectation.fulfill()
		}
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	func queryRestaurants(price: Int) {
		let testExpectation = self.expectation(description: "Tests")
		
		let request = QueryRequest(contentType: contentType)
		request.filter(by: "price", greaterThanOrEqualTo: price)
		
		let task = strapi.exec(request: request, needAuthentication: true) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let list = response.data as? [[String: Any]] else {
				XCTFail("Could not serialize the response")
				return
			}
			XCTAssertGreaterThan(list.count, 0)
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	func fetchRestaurant(id: Int, name: String, price: Int) {
		let testExpectation = self.expectation(description: "Tests")
		
		let request = FetchRequest(
			contentType: contentType,
			id: id
		)
		
		let task = strapi.exec(request: request, needAuthentication: true) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let object = response.data as? [String: Any],
				let name = object["name"] as? String,
				let currentPrice = object["price"] as? Int
				else {
					XCTFail("Could not serialize the response")
					return
			}
			XCTAssertEqual(name, name)
			XCTAssertEqual(currentPrice, price)
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	func updateRestaurant(id: Int, price: Int) {
		let testExpectation = self.expectation(description: "Tests")
		
		let request = UpdateRequest(
			contentType: contentType,
			id: id,
			parameters: [
				"price": price
			]
		)
		
		let task = strapi.exec(request: request, needAuthentication: true) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let object = response.data as? [String: Any],
				let currentPrice = object["price"] as? Int
				else {
					XCTFail("Could not serialize the response")
					return
			}
			XCTAssertEqual(currentPrice, price)
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
	
	func destroyRestaurant(id: Int) {
		let testExpectation = self.expectation(description: "Tests")
		
		let request = DestroyRequest(
			contentType: contentType,
			id: id
		)
		
		let task = strapi.exec(request: request, needAuthentication: true) { response in
			XCTAssertNil(response.error)
			XCTAssertNotNil(response.data)
			guard let object = response.data as? [String: Any],
				let destroyedId = object["id"] as? Int
				else {
					XCTFail("Could not serialize the response")
					return
			}
			XCTAssertEqual(destroyedId, id)
			testExpectation.fulfill()
		}
		
		XCTAssertNotNil(task)
		let waiterResult = XCTWaiter.wait(for: [testExpectation], timeout: timeout)
		XCTAssertEqual(waiterResult, .completed)
	}
}
