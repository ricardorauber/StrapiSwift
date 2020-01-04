import UIKit
import Strapi_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Setup the shared Strapi instance
		let strapi = Strapi.shared
		strapi.host = "localhost"
		strapi.port = 1337
		
		return true
	}
}

