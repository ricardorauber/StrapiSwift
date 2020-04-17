import Quick
import Nimble
@testable import StrapiSwift

class CountRequestTests: QuickSpec {
	override func spec() {
		
		var request: CountRequest!
		
		describe("CountRequest") {
			
			context("initialization") {
				
				it("should create the request with the right values for a string content type") {
					request = CountRequest(contentType: "restaurant")
					expect(request.method) == .get
					expect(request.contentType) == "restaurants"
					expect(request.path) == "/count"
					expect(request.parameters.count) == 0
				}
				
				it("should create the request with the right values for a static content type") {
					request = CountRequest(contentType: .restaurant)
					expect(request.method) == .get
					expect(request.contentType) == "restaurants"
					expect(request.path) == "/count"
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
