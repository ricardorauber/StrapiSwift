import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = storyboard.instantiateInitialViewController()
		window?.makeKeyAndVisible()
		
		return true
	}
}
