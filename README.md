# StrapiSwift - A Swift toolkit to connect with your Strapi backend

[![Build Status](https://travis-ci.com/ricardorauber/StrapiSwift.svg?branch=master)](http://travis-ci.com/)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/StrapiSwift.svg?style=flat)](http://cocoadocs.org/docsets/StrapiSwift)
[![License](https://img.shields.io/cocoapods/l/StrapiSwift.svg?style=flat)](http://cocoadocs.org/docsets/StrapiSwift)
[![Platform](https://img.shields.io/cocoapods/p/StrapiSwift.svg?style=flat)](http://cocoadocs.org/docsets/StrapiSwift)

This project was built to make it easier to connect your app to your `Strapi` backend, the open source Headless CMS Front-End Developers love, see more at [https://strapi.io/](https://strapi.io/)

## Setup

This project has dependencies:

- [KeyValueStorage: A key-value storage module for Swift projects](https://github.com/ricardorauber/KeyValueStorage)
- [RestService - A light REST service framework for iOS projects](https://github.com/ricardorauber/RestService)

#### CocoaPods

If you are using CocoaPods, add this to your Podfile and run `pod install`.

```ruby
target 'Your target name' do
  pod 'StrapiSwift', '~> 1.0'
end
```

#### Manual Installation

If you want to add it manually to your project, without a package manager, just copy all files from the `Classes` folder to your project.

You have to install the dependencies as well. Please follow their  instructions.

## Usage

### Import StrapiSwift

To use `StrapiSwift` you just need to import the package:

```swift
import StrapiSwift
```

### Start the Service

To start the service, you need to specify your `Strapi` host in the `Strapi` instance:

```swift
let strapi = Strapi(scheme: .http, host: "localhost", port: 1337)
```

But you can use the shared instance as well:

```swift
let strapi = Strapi.shared
strapi.scheme = .http
strapi.host = "localhost"
strapi.port = 1337
```

### Default routes for Content Types

When you create a content type on `Strapi`, it will automatically generate a bunch of routes (`REST APIs`) for that content type, such as create records, read records, update records and destroy records. Sounds familiar? Yes, it has a full `CRUD` right away! This is one of the amazing things `Strapi` does. So, `StrapiSwift` has all of those requests covered, please see below. 

Let's say we have a content type named `restaurant` with a `name` and `price` fields. Here are a few examples on how to integrate with it:

#### CreateRequest (POST)

To start or to grow our database, we can create some records:

```swift
let request = CreateRequest(
	contentType: "restaurant",
	parameters: [
		"name": "Super Pizza",
		"price": 3
	]
)
strapi.exec(request: request) { response in
	guard let record = response.dictionaryValue(),
		let id = record["id"] as? Int
		else {
			return
	}
	print("Created record with id: \(id)")
}
```

#### CountRequest (GET)

Let's say we want to know how many records we have in this content type, we can count them:

```swift
let request = CountRequest(contentType: "restaurant")

strapi.exec(request: request) { response in
	guard let count = response.intValue() else {
		return
	}
	print("Total records: \(count)")
}
```

#### QueryRequest (GET)

Now what you want is to search for all restaurants with some filters and sorting:

```swift
let request = QueryRequest(contentType: "restaurant")
request.filter(by: "name", contains: "pizza")
request.filter(by: "price", greaterThanOrEqualTo: 3)
request.sort(by: "price")

strapi.exec(request: request) { response in
	guard let list = response.decodableValue(of: [Restaurant].self) else {
		return
	}
	print("Records found: \(list)")
}
```

#### FetchRequest (GET)

Sometimes we have just the `id` of a record and we need to get all its information. For that, we can fetch the record by the id:

```swift
let request = FetchRequest(
	contentType: "restaurant",
	id: 10
)

strapi.exec(request: request) { response in
	guard let record = response.decodableValue(of: Restaurant.self) else {
		return
	}
	print("Data retrieved: \(record)")
}
```

#### UpdateRequest (PUT)

Wrong price range? No problem, we can update the record:

```swift
let request = UpdateRequest(
	contentType: "restaurant",
	id: 10,
	parameters: [
		"price": 5
	]
)

strapi.exec(request: request) { response in
	guard let record = response.decodableValue(of: Restaurant.self) else {
		return
	}
	print("Updated record: \(record)")
}
```

#### DestroyRequest (DELETE)

Oh dear, I loved that restaurant! I am sorry that you want to destroy it, but this is how you can do it:

```swift
let request = DestroyRequest(
	contentType: "restaurant",
	id: 10
)

strapi.exec(request: request) { response in
	guard let record = response.dictionaryValue() else {
		return
	}
	print("Destroyed record: \(record)")
}
```

#### Custom Request (?)

So you want to create your custom request because you have a custom route or just want to do it by yourself, here is how you can do it:

```swift
let request = StrapiRequest(
	method: .get,
	contentType: "restaurants", // You can use any route here
	parameters: [
		"price_eq": 3
	]
)

strapi.exec(request: request) { response in
	guard let list = response.decodableValue(of: [Restaurant].self) else {
		return
	}
	print("Data retrieved: \(list)")
}
```

### Users - Permissions

`Strapi` comes with some amazing plugins and one of them is to manage users and permissions. Here are some cool methods we have for it.

#### User Registration

Right now, `StrapiSwift` only works with the local provider for user registration. To do that, you can call it right from the `Strapi` instance:

```swift
strapi.register(
	username: "My name",
	email: "my@email.com",
	password: "VeryStrongPassword@2020") { response in
			
	guard let record = response.decodableValue(of: User.self) else {
		return
	}
	print("New user: \(record)")
}
```

#### Login

With the user confirmed, you can easily log in:

```swift
strapi.login(
	identifier: "my@email.com",
	password: "VeryStrongPassword@2020") { response in
			
	guard let record = response.decodableValue(of: User.self) else {
		return
	}
	print("Logged in user: \(record)")
}
```

#### Forgot Password

If you don't remember your password, here is how you can request an email to reset the password:

```swift
strapi.forgotPassword(email: "my@email.com") { response in
	guard let record = response.dictionaryValue() else {
		return
	}
	print("Some data: \(record)")
}
```

#### Reset Password

After receiving the email with the code to reset the password, this is how you can reset it:

```swift
strapi.resetPassword(
	code: "somerandomcode",
	password: "EvenStrongerPassword@2020",
	passwordConfirmation: "EvenStrongerPassword@2020") { response in
		
	guard let record = response.dictionaryValue() else {
		return
	}
	print("Some data: \(record)")
}
```

### Send Email Confirmation

Hmm, didn't receive the email confirmation? You can ask for it again with this:

```swift
strapi.sendEmailConfirmation(email: "my@email.com") { response in
	guard let record = response.dictionaryValue() else {
		return
	}
	print("Some data: \(record)")
}
```

### Me

Now you just want to retrieve your own data (`User`), it is easy as well:

```swift
strapi.me { response in
	guard let record = response.decodableValue(of: User.self) else {
		return
	}
	print("My data: \(record)")
}
```

## User Session

When you use the `login` method, it will automatically save the retrieved token. If you didn't change the `storage` property, it will save the token on your `Keychain`.

If you need to set this token in a request, you can set the `interceptor` parameter with a `StrapiAuthorizationInterceptor` instance on the `strapi.exec(...)` method:

```swift
let request = StrapiRequest(
	method: .get,
	contentType: "restaurants", // You can use any route here
	parameters: [
		"price_eq": 3
	]
)

let interceptor = StrapiAuthorizationInterceptor(storage: strapi.storage)

strapi.exec(request: request, interceptor: interceptor) { response in
	guard let list = response.decodableValue(of: [Restaurant].self) else {
		return
	}
	print("Data retrieved: \(list)")
}
```

You can create your own `interceptor`, just follow the instructions on the [RestService](https://github.com/ricardorauber/RestService) framework.

## Upload

Another great plugin is `Upload` where you can upload files to your `Strapi` server and create a relation with your record. For instance, it's really easy to send an audio for a message in a chat app.

### Data Upload

Let's upload a text file for a record:

```swift
let text = "..."

strapi.upload(
	contentType: "about",
	id: 1,
	field: "terms",
	filename: "terms.txt",
	mimeType: "text/plain",
	fileData: text.data(using: .utf8)!) { response in
	
	guard let record = response.dictionaryValue() else {
		return
	}
	print("Some data: \(record)")
}
```

### Image Upload

As we usually do a lot of image uploading, like updating your profile picture, we have a convenience method for that:

```swift
let image = UIImage(...)

strapi.upload(
	contentType: "about",
	id: 1,
	field: "terms",
	image: image,
	compressionQuality: 90) { response in
	
	guard let record = response.dictionaryValue() else {
		return
	}
	print("Some data: \(record)")
}
```

## Error Handling

Yes, unfortunately errors can happen, but we can cover some of them. The `response` object has an `error` property that will be set when some non-content error happen, like a `500 status` returned from the server. Also, your `Strapi` backend could send some custom error messages in the body of the response, for that you can check the `strapiError()` method. All you need to do is this:

```swift
strapi.exec(request: request) { response in
	if let error = response.error {
		// There was a connection failure
		print(error)
		return
	if let error = response.strapiError() {
		// Oh no, something went wrong with your data :(
		print(error)
		return
	}
	// Cool, no errors!
}
```

The `strapiError()` method will return an instance of the `StrapiError` model. This object has a few useful properties:

- statusCode: (`Int`) Status code given in the response body
- error: (`String`) Error text given in the response body
- response: (`Data?`) Original response from the server
- message: (`String?`) Text message when the `message` field is a `String` in the response body
- messages: (`[StrapiMessage]`) A list of messages when the `message` field is an `Array` in the response body
- data: (`Any?`) Content of the `data` field from the response body

## ContentType

There is also a special object called `ContentType `. As you can see, it is very simple:

```Swift
struct ContentType: RawRepresentable, Equatable, Hashable {
	typealias RawValue = String
	let rawValue: String
	init(rawValue: String) {
		self.rawValue = rawValue
	}
}
```

With `ContentType` you can create `static` properties to avoid using string in your calls. You can use these properties to make requests:

```Swift
extension ContentType {
	static let restaurant = RestPath(rawValue: "restaurant")
}

let request = FetchRequest(
	contentType: .restaurant,
	id: 10
)
```

## Thanks 👍

The creation of this framework was possible thanks to these awesome people:

* Gray Company: [https://www.graycompany.com.br/](https://www.graycompany.com.br/)
* Strapi: [https://strapi.io/](https://strapi.io/)
* Swift by Sundell: [https://www.swiftbysundell.com/](https://www.swiftbysundell.com/)
* Hacking with Swift: [https://www.hackingwithswift.com/](https://www.hackingwithswift.com/)
* Ricardo Rauber: [http://ricardorauber.com/](http://ricardorauber.com/)

## Feedback is welcome

If you notice any issue, got stuck or just want to chat feel free to create an issue. We will be happy to help you.

## License

StrapiSwift is released under the [MIT License](LICENSE).
