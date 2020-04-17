import Quick
import Nimble
@testable import StrapiSwift

class UpdateRequestTests: QuickSpec {
	override func spec() {
		
		var request: UpdateRequest!
		
		describe("UpdateRequest") {
			
			context("initialization") {
				
				it("should create the request with the right values for a string content type") {
					request = UpdateRequest(contentType: "restaurant", id: 10, parameters: ["dummy": "value"])
					expect(request.method) == .put
					expect(request.contentType) == "restaurants"
					expect(request.path) == "/10"
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? String) == "value"
				}
				
				it("should create the request with the right values for a static content type") {
					request = UpdateRequest(contentType: .restaurant, id: 10, parameters: ["dummy": "value"])
					expect(request.method) == .put
					expect(request.contentType) == "restaurants"
					expect(request.path) == "/10"
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
