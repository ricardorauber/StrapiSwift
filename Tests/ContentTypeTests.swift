import Quick
import Nimble
@testable import StrapiSwift

class ContentTypeTests: QuickSpec {
	override func spec() {
		
		describe("ContentType") {
			
			context("equality") {
				
				it("same components should be true") {
					let contentType1: ContentType = .contentType1
					let contentType2: ContentType = .contentType1
					expect(contentType1 == contentType2).to(beTrue())
				}
				
				it("different components should be false") {
					let contentType1: ContentType = .contentType1
					let contentType2: ContentType = .contentType2
					expect(contentType1 == contentType2).to(beFalse())
				}
			}
			
			context("difference") {
				
				it("same components should be false") {
					let contentType1: ContentType = .contentType1
					let contentType2: ContentType = .contentType1
					expect(contentType1 != contentType2).to(beFalse())
				}
				
				it("different components should be true") {
					let contentType1: ContentType = .contentType1
					let contentType2: ContentType = .contentType2
					expect(contentType1 != contentType2).to(beTrue())
				}
			}
		}
	}
}

// MARK: - Private helpers

private extension ContentType {

	static let contentType1 = ContentType(rawValue: "contentType1")
	static let contentType2 = ContentType(rawValue: "contentType2")
}
