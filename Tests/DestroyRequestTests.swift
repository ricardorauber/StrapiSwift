import Quick
import Nimble
@testable import StrapiSwift

class DestroyRequestTests: QuickSpec {
	override func spec() {
		
		var request: DestroyRequest!
		
		describe("DestroyRequest") {
			
			context("initialization") {
				
				it("should create the request with the right values for a string content type") {
					request = DestroyRequest(contentType: "restaurant", id: 10)
					expect(request.method) == .delete
					expect(request.contentType) == "restaurants"
					expect(request.path) == "/10"
					expect(request.parameters.count) == 0
				}
				
				it("should create the request with the right values for a static content type") {
					request = DestroyRequest(contentType: .restaurant, id: 10)
					expect(request.method) == .delete
					expect(request.contentType) == "restaurants"
					expect(request.path) == "/10"
					expect(request.parameters.count) == 0
				}
			}
		}
	}
}

// MARK: - Private helpers

private extension ContentType {
	static let restaurant = ContentType(rawValue: "restaurant")
}
