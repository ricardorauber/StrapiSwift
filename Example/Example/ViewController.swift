import UIKit
import Strapi

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		print(Strapi.shared.host)
	}
}

