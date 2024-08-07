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
* Continuous integration with Github Actions and Danger
* Unit testing, including [testing view controllers for leaks](https://blog.kulman.sk/unit-testing-memory-leaks/)
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

* Xcode 15
* [Fastlane](https://fastlane.tools/) (optional)

## Built with

- [RxSwift](https://github.com/ReactiveX/RxSwift) - Reactive Programming in Swift
- [RxSwiftExt](https://github.com/RxSwiftCommunity/RxSwiftExt) - A collection of Rx operators & tools not found in the core RxSwift distribution
- [Swinject](https://github.com/Swinject/Swinject) - Dependency injection framework for Swift
- [Reusable](https://github.com/AliSoftware/Reusable) - A Swift mixin for reusing views easily and in a type-safe way
- [Nuke](https://github.com/kean/Nuke) - A powerful image loading and caching system
- [FeedKit](https://github.com/nmdias/FeedKit) - An RSS, Atom and JSON Feed parser written in Swift
- [NotificationBanner](https://github.com/Daltron/NotificationBanner) - The easiest way to display highly customizable in app notification banners in iOS
- [SpecLeaks](leandromperez/specleaks) - Unit Tests Memory Leaks in Swift. Write readable tests for mem leaks easily with these Quick and Nimble extensions
- [Quick](https://github.com/Quick/Quick) - The Swift (and Objective-C) testing framework
- [Nimble](https://github.com/Quick/Nimble) - A Matcher Framework for Swift and Objective-C
- [SwifLint](https://github.com/realm/SwiftLint) - A tool to enforce Swift style and conventions

## Author

Igor Kulman - igor@kulman.sk

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
