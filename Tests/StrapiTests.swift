import UIKit
import Quick
import Nimble
import OHHTTPStubs
import KeyValueStorage
import RestService
@testable import StrapiSwift

class StrapiTests: QuickSpec {
	override func spec() {
		
		var strapi: Strapi!
		var storage: KeyValueStorage!
		var service: RestService!
		
		beforeEach {
			storage = MemoryKeyValueStorage()
			service = RestService(host: "server.com")
			strapi = Strapi(storage: storage, service: service)
			HTTPStubs.removeAllStubs()
			stub(condition: isHost("server.com")) { _ in
				return HTTPStubsResponse(jsonObject: ["jwt": "abcde"], statusCode: 200, headers: nil)
			}
		}
		
		describe("Strapi") {
			
			context("initialization") {
				
				it("should create an instance with the default values") {
					expect(strapi.storage).to(beIdenticalTo(storage))
					expect(strapi.service).to(beIdenticalTo(service))
					expect(strapi.scheme) == .https
					expect(strapi.host) == "server.com"
					expect(strapi.port).to(beNil())
				}
				
				it("should create an instance with the given values") {
					strapi = Strapi(scheme: .http, host: "api.com", port: 3000)
					expect(strapi.storage).to(beAnInstanceOf(KeychainKeyValueStorage.self))
					expect(strapi.service.session).to(beIdenticalTo(URLSession.shared))
					expect(strapi.scheme) == .http
					expect(strapi.host) == "api.com"
					expect(strapi.port) == 3000
				}
			}
			
			context("properties") {
				
				it("should set the service resume tasks automatically flag to false") {
					service = RestService(host: "somethingelse.com")
					service.resumeTasksAutomatically = true
					strapi.service = service
					expect(strapi.service).to(beIdenticalTo(service))
					expect(strapi.service.resumeTasksAutomatically).to(beFalse())
				}
				
				it("should set the right scheme on the service") {
					strapi.scheme = .http
					expect(strapi.service.scheme) == .http
				}
				
				it("should set the right host on the service") {
					strapi.host = "somethingelse.com"
					expect(strapi.service.host) == "somethingelse.com"
				}
				
				it("should set the right port on the service") {
					strapi.port = 3000
					expect(strapi.service.port) == 3000
				}
			}
			
			context("users") {
				
				it("should create a valid register request") {
					var completed = false
					let task = strapi.register(
						username: "john",
						email: "john@server.com",
						password: "mydog") { response in
							expect(response.request?.httpMethod) == "POST"
							expect(response.request?.url?.host) == "server.com"
							expect(response.request?.url?.path) == "/auth/local/register"
							let body = dict(from: response.request?.httpBody)
							expect(body).toNot(beNil())
							expect(body).toNot(beNil())
							expect(body?["username"] as? String) == "john"
							expect(body?["email"] as? String) == "john@server.com"
							expect(body?["password"] as? String) == "mydog"
							completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should create a valid login request") {
					var completed = false
					let task = strapi.login(
						identifier: "john@server.com",
						password: "mydog") { response in
							expect(response.request?.httpMethod) == "POST"
							expect(response.request?.url?.host) == "server.com"
							expect(response.request?.url?.path) == "/auth/local"
							let body = dict(from: response.request?.httpBody)
							expect(body).toNot(beNil())
							expect(body).toNot(beNil())
							expect(body?["identifier"] as? String) == "john@server.com"
							expect(body?["password"] as? String) == "mydog"
							expect(storage.getString(for: .strapiAuthorizationKey)) == "abcde"
							completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should create a valid forgot password request") {
					var completed = false
					let task = strapi.forgotPassword(email: "john@server.com") { response in
						expect(response.request?.httpMethod) == "POST"
						expect(response.request?.url?.host) == "server.com"
						expect(response.request?.url?.path) == "/auth/forgot-password"
						let body = dict(from: response.request?.httpBody)
						expect(body).toNot(beNil())
						expect(body).toNot(beNil())
						expect(body?["email"] as? String) == "john@server.com"
						completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should create a valid reset password request") {
					var completed = false
					let task = strapi.resetPassword(
						code: "12345",
						password: "mydog",
						passwordConfirmation: "mydog") { response in
							expect(response.request?.httpMethod) == "POST"
							expect(response.request?.url?.host) == "server.com"
							expect(response.request?.url?.path) == "/auth/reset-password"
							let body = dict(from: response.request?.httpBody)
							expect(body).toNot(beNil())
							expect(body).toNot(beNil())
							expect(body?["code"] as? String) == "12345"
							expect(body?["password"] as? String) == "mydog"
							expect(body?["passwordConfirmation"] as? String) == "mydog"
							completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should create a valid send email confirmation request") {
					var completed = false
					let task = strapi.sendEmailConfirmation(email: "john@server.com") { response in
						expect(response.request?.httpMethod) == "POST"
						expect(response.request?.url?.host) == "server.com"
						expect(response.request?.url?.path) == "/auth/send-email-confirmation"
						let body = dict(from: response.request?.httpBody)
						expect(body).toNot(beNil())
						expect(body).toNot(beNil())
						expect(body?["email"] as? String) == "john@server.com"
						completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should create a valid forgot password request") {
					var completed = false
					let task = strapi.me { response in
						expect(response.request?.httpMethod) == "GET"
						expect(response.request?.url?.host) == "server.com"
						expect(response.request?.url?.path) == "/users/me"
						expect(response.request?.httpBody).to(beNil())
						completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
			}
			
			context("files") {
				
				it("should create a valid file upload request") {
					var completed = false
					let task = strapi.upload(
						contentType: "restaurant",
						id: 10,
						field: "photo",
						source: "plugin",
						path: "path",
						filename: "image.jpg",
						mimeType: "image/jpg",
						fileData: "image".data(using: .utf8)!) { response in
							expect(response.request?.httpMethod) == "POST"
							expect(response.request?.url?.host) == "server.com"
							expect(response.request?.url?.path) == "/upload"
							let headerPrefix = "multipart/form-data; boundary="
							let boundary = response.request?.allHTTPHeaderFields?["Content-Type"]?.dropFirst(headerPrefix.count)
							expect(boundary).toNot(beNil())
							expect(response.request?.httpBody).toNot(beNil())
							let body = String(data: response.request!.httpBody!, encoding: .utf8)
							expect(body).toNot(beNil())
							expect(body) == "--\(boundary!)\r\nContent-Disposition: form-data; name=\"ref\"\r\n\r\nrestaurant\r\n--\(boundary!)\r\nContent-Disposition: form-data; name=\"refId\"\r\n\r\n10\r\n--\(boundary!)\r\nContent-Disposition: form-data; name=\"field\"\r\n\r\nphoto\r\n--\(boundary!)\r\nContent-Disposition: form-data; name=\"source\"\r\n\r\nplugin\r\n--\(boundary!)\r\nContent-Disposition: form-data; name=\"path\"\r\n\r\npath\r\n--\(boundary!)\r\nContent-Disposition: form-data; name=\"files\"; filename=\"image.jpg\"\r\nContent-Type: \"image/jpg\"\r\n\r\nimage\r\n--\(boundary!)--\r\n"
							completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should create a valid image upload request") {
					var completed = false
					let image = UIImage(color: .blue, size: CGSize(width: 10, height: 10))
					let task = strapi.upload(
						contentType: "restaurant",
						id: 10,
						field: "photo",
						image: image,
						compressionQuality: 1) { response in
							expect(response.request?.httpMethod) == "POST"
							expect(response.request?.url?.host) == "server.com"
							expect(response.request?.url?.path) == "/upload"
							let headerPrefix = "multipart/form-data; boundary="
							let boundary = response.request?.allHTTPHeaderFields?["Content-Type"]?.dropFirst(headerPrefix.count)
							expect(boundary).toNot(beNil())
							expect(response.request?.httpBody).toNot(beNil())
							completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should not create an image upload request with an invalid compression quality") {
					let image = UIImage(color: .blue, size: CGSize(width: 0, height: 0))
					let task = strapi.upload(
						contentType: "restaurant",
						id: 10,
						field: "photo",
						image: image,
						compressionQuality: -1) { _ in }
					expect(task).to(beNil())
				}
			}
			
			context("exec") {
				
				it("should create a task from a given request without path") {
					var completed = false
					let request = StrapiRequest(
						method: .get,
						contentType: "restaurant"
					)
					let task = strapi.exec(request: request) { response in
						expect(response.request?.httpMethod) == "GET"
						expect(response.request?.url?.host) == "server.com"
						expect(response.request?.url?.path) == "/restaurant"
						completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should create a task from a given request without path") {
					var completed = false
					let request = StrapiRequest(
						method: .get,
						contentType: "restaurant",
						path: "/10"
					)
					let task = strapi.exec(request: request) { response in
						expect(response.request?.httpMethod) == "GET"
						expect(response.request?.url?.host) == "server.com"
						expect(response.request?.url?.path) == "/restaurant/10"
						completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
			}
			
			context("errors") {
				
				beforeEach {
					HTTPStubs.removeAllStubs()
				}
				
				it("should get an error with a string message from the server") {
					stub(condition: isHost("server.com")) { _ in
						let response: [String: Any] = [
							"statusCode": 403,
							"error": "Forbidden",
							"message": "Forbidden"
						]
						return HTTPStubsResponse(jsonObject: response, statusCode: 403, headers: nil)
					}
					var completed = false
					let request = StrapiRequest(
						method: .get,
						contentType: "restaurant"
					)
					let task = strapi.exec(request: request) { response in
						let error = response.strapiError()
						expect(error).toNot(beNil())
						expect(error?.statusCode) == 403
						expect(error?.error) == "Forbidden"
						expect(error?.message) == "Forbidden"
						completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
				
				it("should get an error with a list of messages from the server") {
					stub(condition: isHost("server.com")) { _ in
						let response: [String: Any] = [
							"statusCode": 400,
							"error": "Bad Request",
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
						return HTTPStubsResponse(jsonObject: response, statusCode: 400, headers: nil)
					}
					var completed = false
					let request = StrapiRequest(
						method: .get,
						contentType: "restaurant"
					)
					let task = strapi.exec(request: request) { response in
						let error = response.strapiError()
						expect(error).toNot(beNil())
						expect(error?.statusCode) == 400
						expect(error?.error) == "Bad Request"
						expect(error?.messages.count) == 1
						expect(error?.messages.first?.id) == "Auth.form.error.invalid"
						expect(error?.messages.first?.message) == "Identifier or password invalid."
						completed = true
					}
					expect(task).toNot(beNil())
					expect(completed).toEventually(beTrue(), timeout: 1)
				}
			}
		}
	}
}

// MARK: - Private helpers

private func dict(from: Data?) -> [String: Any]? {
	guard let data = from else { return nil }
	return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
}

private extension UIImage {
	
	convenience init(color: UIColor, size: CGSize) {
		UIGraphicsBeginImageContextWithOptions(size, false, 1)
		defer {
			UIGraphicsEndImageContext()
		}
		color.setFill()
		UIRectFill(CGRect(origin: .zero, size: size))
		guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
			self.init()
			return
		}
		self.init(cgImage: aCgImage)
	}
}
