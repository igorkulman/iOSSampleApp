# iOS Sample App

Sample iOS app written the way I write iOS apps because I cannot share the app I currently work on.

**SwiftUI**: I created a SwiftUI version of this sample app, using a bit defferent concepts: https://github.com/igorkulman/SwiftUISampleApp

## Shown concepts

### Architecture concepts

* [Coordinators](https://blog.kulman.sk/architecting-ios-apps-coordinators/)
* Dependency Injection
* MVVM
* [Data Binding](https://blog.kulman.sk/using-data-binding-in-ios/)
* Dependencies management

### Other concepts

* Localization to 2 languages with String catalogs
* Continuous integration with Github Actions
* Unit testing, including testing view controllers for leaks
* Creating a view controller in code with dependency injection
* Using static UITableView cells in a typed way with enums
* Creating simple cells with UIListContentConfiguration
* Automated AppStore screenshots taking in multiple languages
* Adding custom reactive properties
* Basic Dark mode support
* Custom operator for simple UI code
* Structured logging
* Xcode build plugins
* Xcode previews for UIKit

## Getting started

### Prerequisites

* Xcode 16
* [Fastlane](https://fastlane.tools/) (optional)

## Built with

- [RxSwift](https://github.com/ReactiveX/RxSwift) - Reactive Programming in Swift
- [RxSwiftExt](https://github.com/RxSwiftCommunity/RxSwiftExt) - A collection of Rx operators & tools not found in the core RxSwift distribution
- [FeedKit](https://github.com/nmdias/FeedKit) - An RSS, Atom and JSON Feed parser written in Swift
- [SwiftLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions

## Author

Igor Kulman - igor@kulman.sk

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
