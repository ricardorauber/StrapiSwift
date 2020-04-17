import Quick
import Nimble
import KeyValueStorage
@testable import StrapiSwift

class StrapiAuthorizationInterceptorTests: QuickSpec {
	override func spec() {
		
		describe("StrapiAuthorizationInterceptor") {
			
			context("adapt") {
				
				it("should not add a header without a token") {
					let storage = MemoryKeyValueStorage()
					let interceptor = StrapiAuthorizationInterceptor(storage: storage)
					var request = URLRequest(url: URL(string: "http://server.com")!)
					request = interceptor.adapt(request: request)
					expect(request.allHTTPHeaderFields).to(beNil())
				}
				
				it("should add a header with a token") {
					let storage = MemoryKeyValueStorage()
					storage.set(string: "abcde", for: .strapiAuthorizationKey)
					let interceptor = StrapiAuthorizationInterceptor(storage: storage)
					var request = URLRequest(url: URL(string: "http://server.com")!)
					request = interceptor.adapt(request: request)
					expect(request.allHTTPHeaderFields?.count) == 1
					expect(request.allHTTPHeaderFields?["Authorization"]) == "Bearer abcde"
				}
			}
		}
	}
}
