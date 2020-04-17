import Quick
import Nimble
@testable import StrapiSwift

class CreateRequestTests: QuickSpec {
	override func spec() {
		
		var request: CreateRequest!
		
		describe("CreateRequest") {
			
			context("initialization") {
				
				it("should create the request with the right values for a string content type") {
					request = CreateRequest(contentType: "restaurant", parameters: ["dummy": "value"])
					expect(request.method) == .post
					expect(request.contentType) == "restaurants"
					expect(request.path).to(beNil())
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? String) == "value"
				}
				
				it("should create the request with the right values for a static content type") {
					request = CreateRequest(contentType: .restaurant, parameters: ["dummy": "value"])
					expect(request.method) == .post
					expect(request.contentType) == "restaurants"
					expect(request.path).to(beNil())
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? String) == "value"
				}
			}
		}
	}
}

// MARK: - Private helpers

private extension ContentType {
	static let restaurant = ContentType(rawValue: "restaurant")
}
