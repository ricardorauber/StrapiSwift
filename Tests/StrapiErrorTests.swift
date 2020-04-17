import Quick
import Nimble
@testable import StrapiSwift

class StrapiErrorTests: QuickSpec {
	override func spec() {
		
		describe("StrapiError") {
			
			context("initialization") {
				
				it("should have the right values") {
					let error = StrapiError(statusCode: 400, error: "invalid")
					expect(error.statusCode) == 400
					expect(error.error) == "invalid"
					expect(error.message).to(beNil())
				}
				
				it("should have the right message") {
					let error = StrapiError(statusCode: 400, error: "invalid", message: "message")
					expect(error.statusCode) == 400
					expect(error.error) == "invalid"
					expect(error.message) == "message"
				}
			}
		}
	}
}
