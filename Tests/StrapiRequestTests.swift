import Quick
import Nimble
import RestService
@testable import StrapiSwift

class StrapiRequestTests: QuickSpec {
	override func spec() {
		
		var request: StrapiRequest!
		
		describe("StrapiRequest") {
			
			beforeEach {
				request = StrapiRequest(method: .get, contentType: "restaurant")
			}
			
			context("initialization") {
				
				it("should have the right data with a string content type and no path") {
					request = StrapiRequest(method: .get, contentType: "restaurant")
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.path).to(beNil())
					expect(request.parameters.count) == 0
				}
				
				it("should have the right data with a string content type and a string path") {
					request = StrapiRequest(method: .get, contentType: "restaurant", path: "/count")
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.path) == "/count"
					expect(request.parameters.count) == 0
				}
				
				it("should have the right data with a string content type and a static path") {
					request = StrapiRequest(method: .get, contentType: "restaurant", path: [.count])
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.path) == "/count"
					expect(request.parameters.count) == 0
				}
				
				it("should have the right data with a static content type and no path") {
					request = StrapiRequest(method: .get, contentType: .restaurant)
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.path).to(beNil())
					expect(request.parameters.count) == 0
				}
				
				it("should have the right data with a static content type and a string path") {
					request = StrapiRequest(method: .get, contentType: .restaurant, path: "/count")
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.path) == "/count"
					expect(request.parameters.count) == 0
				}
				
				it("should have the right data with a static content type and a static path") {
					request = StrapiRequest(method: .get, contentType: .restaurant, path: [.count])
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.path) == "/count"
					expect(request.parameters.count) == 0
				}
				
				it("should have the right data with a string content type and some parameters") {
					request = StrapiRequest(method: .get, contentType: "restaurant", parameters: ["dummy": 10])
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
				}
				
				it("should have the right data with a static content type and some parameters") {
					request = StrapiRequest(method: .get, contentType: .restaurant, parameters: ["dummy": 10])
					expect(request.method) == .get
					expect(request.contentType) == "restaurant"
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
				}
			}
			
			context("buildPath") {
				
				it("should create a string path with a single component") {
					let path: [RestPath] = [.restaurants]
					expect(request.buildPath(path)) == "/restaurants"
				}
				
				it("should create a string path with multiple static components") {
					let path: [RestPath] = [.restaurants, .count]
					expect(request.buildPath(path)) == "/restaurants/count"
				}
				
				it("should create a string path with multiple components") {
					let path: [RestPath] = [.restaurants, .count, RestPath(rawValue: "10")]
					expect(request.buildPath(path)) == "/restaurants/count/10"
				}
			}
			
			context("parameters") {
				
				it("should set the right parameter") {
					request.setParameter(key: "dummy", value: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
				}
				
				it("should override the right parameter") {
					request.setParameter(key: "dummy", value: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
					request.setParameter(key: "dummy", value: 20)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 20
				}
				
				it("should remove all parameters") {
					request.setParameter(key: "dummy", value: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
					request.setParameter(key: "dummy2", value: 20)
					expect(request.parameters.count) == 2
					expect(request.parameters["dummy2"] as? Int) == 20
					request.removeAllParameters()
					expect(request.parameters.count) == 0
				}
			}
			
			context("filters") {
				
				it("should not set a filter for a request that is not a query") {
					request.method = .post
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 0
					request.removeAllFilters()
					expect(request.parameters.count) == 0
					request.method = .put
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 0
					request.removeAllFilters()
					expect(request.parameters.count) == 0
					request.method = .connect
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 0
					request.removeAllFilters()
					expect(request.parameters.count) == 0
					request.method = .options
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 0
					request.removeAllFilters()
					expect(request.parameters.count) == 0
					request.method = .patch
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 0
					request.removeAllFilters()
					expect(request.parameters.count) == 0
					request.method = .trace
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 0
					request.removeAllFilters()
					expect(request.parameters.count) == 0
				}
				
				it("should set the right filter for a GET request") {
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
				}
				
				it("should override the right filter for a HEAD request") {
					request.method = .head
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
					request.setFilter(key: "dummy", value: 20)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 20
				}
				
				it("should remove all filters for a DELETE request") {
					request.method = .delete
					request.setFilter(key: "dummy", value: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["dummy"] as? Int) == 10
					request.setFilter(key: "dummy2", value: 20)
					expect(request.parameters.count) == 2
					expect(request.parameters["dummy2"] as? Int) == 20
					request.removeAllFilters()
					expect(request.parameters.count) == 0
				}
				
				it("should set the \"equal to\" filter for a GET request") {
					request.filter(by: "field", equalTo: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_eq"] as? String) == "something"
				}
				
				it("should set the \"not equal to\" filter for a GET request") {
					request.filter(by: "field", notEqualTo: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_ne"] as? String) == "something"
				}
				
				it("should set the \"lower than\" filter for a GET request") {
					request.filter(by: "field", lowerThan: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_lt"] as? String) == "something"
				}
				
				it("should set the \"greater than\" filter for a GET request") {
					request.filter(by: "field", greaterThan: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_gt"] as? String) == "something"
				}
				
				it("should set the \"lower than or equal to\" filter for a GET request") {
					request.filter(by: "field", lowerThanOrEqualTo: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_lte"] as? String) == "something"
				}
				
				it("should set the \"greater than or equal to\" filter for a GET request") {
					request.filter(by: "field", greaterThanOrEqualTo: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_gte"] as? String) == "something"
				}
				
				it("should set the \"contains\" filter for a GET request") {
					request.filter(by: "field", contains: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_contains"] as? String) == "something"
				}
				
				it("should set the \"doesn't contain\" filter for a GET request") {
					request.filter(by: "field", doesntContain: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_ncontains"] as? String) == "something"
				}
				
				it("should set the case sensitive \"contains\" filter for a GET request") {
					request.filter(by: "field", containsCaseSensitive: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_containss"] as? String) == "something"
				}
				
				it("should set the case sensitive \"doesn't contain\" filter for a GET request") {
					request.filter(by: "field", doesntContainCaseSensitive: "something")
					expect(request.parameters.count) == 1
					expect(request.parameters["field_ncontainss"] as? String) == "something"
				}
				
				it("should set the \"is null\" filter for a GET request") {
					request.filter(by: "field", isNull: true)
					expect(request.parameters.count) == 1
					expect(request.parameters["field_null"] as? Bool) == true
				}
				
				it("should set the \"is not null\" filter for a GET request") {
					request.filter(by: "field", isNull: false)
					expect(request.parameters.count) == 1
					expect(request.parameters["field_null"] as? Bool) == false
				}
				
				it("should set the \"in\" filter for a GET request") {
					request.filter(by: "field", in: "something")
					expect(request.parameters.count) == 1
					var list = request.parameters["field_in"] as? [String]
					expect(list).toNot(beNil())
					expect(list?.first) == "something"
					request.filter(by: "field", in: "else")
					expect(request.parameters.count) == 1
					list = request.parameters["field_in"] as? [String]
					expect(list).toNot(beNil())
					expect(list?.first) == "something"
					expect(list?.last) == "else"
				}
				
				it("should set the \"not in\" filter for a GET request") {
					request.filter(by: "field", notIn: "something")
					expect(request.parameters.count) == 1
					var list = request.parameters["field_nin"] as? [String]
					expect(list).toNot(beNil())
					expect(list?.first) == "something"
					request.filter(by: "field", notIn: "else")
					expect(request.parameters.count) == 1
					list = request.parameters["field_nin"] as? [String]
					expect(list).toNot(beNil())
					expect(list?.first) == "something"
					expect(list?.last) == "else"
				}
				
				it("should not set the \"in\" filter for a POST request") {
					request.method = .post
					request.filter(by: "field", in: "something")
					expect(request.parameters.count) == 0
				}
				
				it("should not set the \"not in\" filter for a POST request") {
					request.method = .post
					request.filter(by: "field", notIn: "something")
					expect(request.parameters.count) == 0
				}
			}
			
			context("response settings") {
				
				it("should set a limit for a GET request") {
					request.limit(by: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["_limit"] as? Int) == 10
				}
				
				it("should set the starting index for a GET request") {
					request.start(at: 10)
					expect(request.parameters.count) == 1
					expect(request.parameters["_start"] as? Int) == 10
				}
			}
			
			context("sorting") {
				
				it("should add sorting values on a GET request") {
					request.sort(by: "name")
					expect(request.parameters.count) == 1
					expect(request.parameters["_sort"] as? String) == "name:ASC"
					request.sort(by: "age", ascending: false)
					expect(request.parameters.count) == 1
					expect(request.parameters["_sort"] as? String) == "name:ASC,age:DESC"
					request.sort(by: "role", ascending: true)
					expect(request.parameters.count) == 1
					expect(request.parameters["_sort"] as? String) == "name:ASC,age:DESC,role:ASC"
				}
				
				it("should remove all sorting values from a GET request") {
					request.sort(by: "name")
					expect(request.parameters.count) == 1
					request.removeAllSortingByItems()
					expect(request.parameters.count) == 0
				}
				
				it("should not add sorting values on a POST request") {
					request.method = .post
					request.sort(by: "name")
					expect(request.parameters.count) == 0
				}
				
				it("should remove all sorting values from a POST request") {
					request.method = .post
					request.sort(by: "name")
					expect(request.parameters.count) == 0
					request.removeAllSortingByItems()
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

private extension RestPath {
	static let restaurants = RestPath(rawValue: "restaurants")
	static let count = RestPath(rawValue: "count")
}
