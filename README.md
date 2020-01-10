# Strapi iOS

This project was built to make it easier to connect your app to your Strapi backend, the open source Headless CMS Front-End Developers love, see more at [https://strapi.io/](https://strapi.io/)

## Contents

- [Installation](#installation)
- [Usage](#usage)
- [User Session](#user-session)
- [Upload](#upload)
- [Error Handling](#error-handling)
- [License](#license)

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Strapi-iOS into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Strapi-iOS'
```

## Usage

### Import Strapi-iOS

To use Strapi-iOS you just need to import the package:

```swift
import Strapi_iOS
```

### Start the Service

To start the service, you need to specify your Strpi host in the Strapi instance. In a general usage, you will add this information at launch time, in the AppDelegate class:

```swift
import UIKit
import Strapi_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		// Setup the shared Strapi instance
		let strapi = Strapi.shared
		strapi.scheme = "http"
		strapi.host = "localhost"
		strapi.port = 1337
		
		return true
	}
}
```

### Default routes for Content Types

When you create a content type on Strapi, it will automatically generate a bunch of routes (REST APIs) for that content type, such as create records, read records, update records and destroy records. Sounds familiar? Yes, it has a full CRUD right away! This is one of the amazing things Strapi does. So, Strapi-iOS has all of those requests covered, please see below. 

Let's say we have a content type named `Restaurant` with a `Name` and `Price` fields. Here are a few examples on how to integrate with it:

#### CreateRequest (POST)

To start or to grow our database, we can create some records:

```swift
let strapi = Strapi.shared

let request = CreateRequest(
	contentType: "restaurant",
	parameters: [
		"name": "Super Pizza",
		"price": 3
	]
)

strapi.exec(request: request, needAuthentication: false) { response in
	guard let record = response.data as? [String: Any],
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
let strapi = Strapi.shared

let request = CountRequest(contentType: "restaurant")

strapi.exec(request: request, needAuthentication: false) { response in
	guard let count = response.data as? Int else {
		return
	}
	print("Total records: \(count)")
}
```

#### QueryRequest (GET)

Now what you want is to search for all restaurants with some filters and sorting:

```swift
let strapi = Strapi.shared

let request = QueryRequest(contentType: "restaurant")
request.filter(by: "name", contains: "pizza")
request.filter(by: "price", greaterThanOrEqualTo: 3)
request.sort(by: "price")

strapi.exec(request: request, needAuthentication: false) { response in
	guard let list = response.data as? [[String: Any]] else {
		return
	}
	print("Records found: \(list)")
}
```

#### FetchRequest (GET)

Sometimes we have just the `id` of a record and we need to get all its information. For that, we can fetch the record by the id:

```swift
let strapi = Strapi.shared

let request = FetchRequest(
	contentType: "restaurant",
	id: 10
)

strapi.exec(request: request, needAuthentication: false) { response in
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Data retrieved: \(record)")
}
```

#### UpdateRequest (PUT)

Wrong price range? No problem, we can update the record:

```swift
let strapi = Strapi.shared

let request = UpdateRequest(
	contentType: "restaurant",
	id: 10,
	parameters: [
		"price": 5
	]
)

strapi.exec(request: request, needAuthentication: false) { response in
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Updated record: \(record)")
}
```

#### DestroyRequest (DELETE)

Oh dear, I loved that restaurant! I am sorry that you want to destroy it, but this is how you can do it:

```swift
let strapi = Strapi.shared

let request = DestroyRequest(
	contentType: "restaurant",
	id: 10
)

strapi.exec(request: request, needAuthentication: false) { response in
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Destroyed record: \(record)")
}
```

#### Custom Request (?)

So you want to create your custom request because you have a custom route or just want to do it by yourself, here is how you can do it:

```swift
let strapi = Strapi.shared

let request = Request(
	method: "GET",
	contentType: "restaurants", // You can use any route here
	parameters: [
		"price_eq": 3
	]
)

strapi.exec(request: request, needAuthentication: false) { response in
	guard let list = response.data as? [[String: Any]] else {
		return
	}
	print("Data retrieved: \(list)")
}
```

### Users - Permissions

Strapi comes with some amazing plugins and one of them is to manage users and permissions. Here are some cool methods we have for it.

#### User Registration

Right now, Strapi-iOS only works with the local provider for user registration. To do that, you can call it right from the Strapi instance:

```swift
let strapi = Strapi.shared

strapi.register(
	username: "My name",
	email: "my@email.com",
	password: "VeryStrongPassword@2020") { response in
			
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("New user: \(record)")
}
```

#### Login

With the user confirmed, you can easily log in:

```swift
let strapi = Strapi.shared

strapi.login(
	identifier: "my@email.com",
	password: "VeryStrongPassword@2020") { response in
			
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Logged in user: \(record)")
}
```

#### Forgot Password

If you don't remember your password, here is how you can request an email to reset the password:

```swift
let strapi = Strapi.shared

strapi.forgotPassword(email: "my@email.com") { response in
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Some data: \(record)")
}
```

#### Reset Password

After receiving the email with the code to reset the password, this is how you can reset it:

```swift
let strapi = Strapi.shared

strapi.resetPassword(
	code: "somerandomcode",
	password: "EvenStrongerPassword@2020",
	passwordConfirmation: "EvenStrongerPassword@2020") { response in
		
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Some data: \(record)")
}
```

### Send Email Confirmation

Hmm, didn't receive the email confirmation? You can ask for it again with this:

```swift
let strapi = Strapi.shared

strapi.sendEmailConfirmation(email: "my@email.com") { response in
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Some data: \(record)")
}
```

### Me

Now you just want to retrieve your own data (User), it is easy as well:

```swift
let strapi = Strapi.shared

strapi.me { response in
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("My data: \(record)")
}
```

## User Session

When you use the `login` method, it will automatically add the retrieved token on Strapi and it will add it on every request with the `needAuthentication` parameter set to `true` on the `exec` method.

If you have a persistent session, you are probably saving the token somewhere, so all you need to do is set the `token` property of the `Strapi` instance to add it on every request with `needAuthentication = true`.

```swift
let strapi = Strapi.shared
strapi.token = "Some_Token_Received_On_Login"
```

## Upload

Another great plugin is Upload where you can upload files to your Strapi server and create a relation with your record. For instance, it's really easy to send an audio for a message in a chat app.

### Data Upload

Let's upload a text file for a record:

```swift
let strapi = Strapi.shared
let text = "..."

strapi.upload(
	contentType: "about",
	id: 1,
	field: "terms",
	filename: "terms.txt",
	mimeType: "text/plain",
	fileData: text.data(using: .utf8)!,
	needAuthentication: false) { response in
	
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Some data: \(record)")
}
```

### Image Upload

As we usually do a lot of image uploading, like updating your profile picture, we have a convenience method for that:

```swift
let strapi = Strapi.shared
let image = UIImage(...)

strapi.upload(
	contentType: "about",
	id: 1,
	field: "terms",
	image: image,
	compressionQuality: 90,
	needAuthentication: false) { response in
	
	guard let record = response.data as? [String: Any] else {
		return
	}
	print("Some data: \(record)")
}
```

## Error Handling

Yes, unfortunately errors can happen, but we can cover some of them. The `response` object has an `error` property that will be set when some non-content error happen, like a `500 status` returned from the server, for instance. All you need to do is check it:

```swift
strapi.exec(request: request, needAuthentication: false) { response in
	if let error = response.error {
		// Oh no, something went wrong :(
		return
	}
	// Cool, no errors!
}
```

## License

Strapi iOS is released under the MIT license. [See LICENSE](https://github.com/ricardorauber/strapi-ios/blob/master/LICENSE) for details.
