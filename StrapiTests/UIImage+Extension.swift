import UIKit

extension UIImage {
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
