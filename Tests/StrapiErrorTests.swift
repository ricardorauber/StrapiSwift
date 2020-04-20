import Quick
import Nimble
@testable import StrapiSwift

class StrapiErrorTests: QuickSpec {
	override func spec() {
		
		describe("StrapiError") {
			
			context("initialization") {
				
				it("should have the required values") {
					let error = StrapiError(statusCode: 403, error: "Forbidden")
					expect(error.statusCode) == 403
					expect(error.error) == "Forbidden"
					expect(error.message).to(beNil())
					expect(error.messages.count) == 0
					expect(error.data).to(beNil())
				}
				
				it("should have the right message") {
					let dictionary = [
						"message": "Forbidden"
					]
					var error = StrapiError(statusCode: 403, error: "Forbidden")
					error.response = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
					expect(error.statusCode) == 403
					expect(error.error) == "Forbidden"
					expect(error.message) == "Forbidden"
					expect(error.messages.count) == 0
				}
				
				it("should have a list of messages") {
					let dictionary = [
						"message": [
							[
								"messages": [
									[
										"id": "Auth.form.error.invalid",
										"message": "Identifier or password invalid."
									]
								]
							]
						]
					]
					var error = StrapiError(statusCode: 400, error: "Bad Request")
					error.response = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
					expect(error.statusCode) == 400
					expect(error.error) == "Bad Request"
					expect(error.message).to(beNil())
					expect(error.messages.count) == 1
					expect(error.messages.first?.id) == "Auth.form.error.invalid"
					expect(error.messages.first?.message) == "Identifier or password invalid."
				}
				
				it("should have some data") {
					let dictionary = [
						"data": "something"
					]
					var error = StrapiError(statusCode: 400, error: "invalid")
					error.response = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
					expect(error.statusCode) == 400
					expect(error.data).toNot(beNil())
					let data = error.data as? String
					expect(data) == "something"
				}
			}
		}
	}
}
