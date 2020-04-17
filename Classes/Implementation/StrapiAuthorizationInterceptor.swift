import KeyValueStorage
import RestService

public struct StrapiAuthorizationInterceptor: RestRequestInterceptor {
	
	public var storage: KeyValueStorage
	
	public init(storage: KeyValueStorage) {
		self.storage = storage
	}
	
	public func adapt(request: URLRequest) -> URLRequest {
		var request = request
		if let token = storage.getString(for: .strapiAuthorizationKey) {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		return request
	}
}
