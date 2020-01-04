import Foundation

extension URLRequest {
	var jsonString: String? {
		guard let body = httpBody,
			let json = try? JSONSerialization.jsonObject(with: body, options: .allowFragments)
			else {
				return nil
		}
		if let dict = json as? [String: Any] {
			return String(describing: dict)
		}
		if let array = json as? [[String: Any]] {
			return String(describing: array)
		}
		return nil
	}
}
