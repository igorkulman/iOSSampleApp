# iOS Sample App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Swift Version](https://img.shields.io/badge/Swift-5-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Twitter](https://img.shields.io/badge/twitter-@igorkulman-blue.svg)](http://twitter.com/igorkulman)

Sample iOS app written the way I write iOS apps because I cannot share the app I currently work on.

## Shown concepts

### Architecture concepts

* [Coordinators](https://blog.kulman.sk/architecting-ios-apps-coordinators/)
* Dependency Injection
* MVVM
* [Data Binding](https://blog.kulman.sk/using-data-binding-in-ios/)
* Dependencies management

### Other concepts

* Localization to 2 languages with [safer string usage](https://blog.kulman.sk/using-ios-strings-in-a-safer-way/) and checking for missing translations
* Continuous integration with Github Actions and Danger
* Unit testing, including [testing view controllers for leaks](https://blog.kulman.sk/unit-testing-memory-leaks/)
* Creating a view controller in code when Storyboard cannot be used
* Using static UITableView cells in a typed way with enums
* Automated AppStore screenshots taking in multiple languages
* Adding custom reactive properties
* Basic Dark mode support
* Custom operator for simple UI code
* Generated code to safely access assets

## Getting started

### Prerequisites

* XCode 14.2
* [SwiftGen](https://github.com/SwiftGen/SwiftGen)
* [SwifLint](https://github.com/realm/SwiftLint) (optional)
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

## Author

Igor Kulman - igor@kulman.sk

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
