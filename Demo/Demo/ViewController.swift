import UIKit
import KeyValueStorage
import StrapiSwift

class ViewController: UIViewController {

	let strapi = Strapi(storage: MemoryKeyValueStorage(), scheme: .http, host: "localhost", port: 1337)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		strapi.login(identifier: "someone@company.com", password: "mypassword") { response in
			print("--LOGIN--")
			print("response", response.dictionaryValue() ?? "-")
			print("message", response.strapiError()?.message ?? "-")
			print("messages", response.strapiError()?.messages ?? "-")
			print("--")
		}
		
		let query = QueryRequest(contentType: "restaurant")
		strapi.exec(request: query) { response in
			print("--QUERY--")
			print("response", response.dictionaryValue() ?? "-")
			print("message", response.strapiError()?.message ?? "-")
			print("messages", response.strapiError()?.messages ?? "-")
			print("--")
		}
	}
}
