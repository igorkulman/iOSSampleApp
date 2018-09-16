# iOS Sample App

[![Travis CI](https://travis-ci.org/igorkulman/iOSSampleApp.svg?branch=master)](https://travis-ci.org/igorkulman/iOSSampleApp)
[![codecov](https://codecov.io/gh/igorkulman/iOSSampleApp/branch/master/graph/badge.svg)](https://codecov.io/gh/igorkulman/iOSSampleApp)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platforms](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
[![Swift Version](https://img.shields.io/badge/Swift-4-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Twitter](https://img.shields.io/badge/twitter-@igorkulman-blue.svg)](http://twitter.com/igorkulman)

### Description

Sample iOS app written the way I write iOS apps because I cannot share the app I currently work on.

### Architecture concepts

* Coordinators
* Dependency Injection (using [Swinject](https://github.com/Swinject/Swinject))
* MVVM
* Binding (using [RxSwift](https://github.com/ReactiveX/RxSwift))
* Dependencies management (using [Carthage](https://github.com/Carthage/Carthage))

### Other concepts

* Continuous integration (using [Travis](https://travis-ci.org/igorkulman/iOSSampleApp))
* Unit testing
* Using (multiple) Storyboards just as glorified XIBs
* Using static UITableView cells in a typed way with enums
* Image literals
* Generated string references (using [SwiftGen](https://github.com/SwiftGen/SwiftGen))
* Automated AppStore screenshots taking (using [Fastlane](https://fastlane.tools/)) 

### Requirements

* Carthage
* XCode 9.4+

#### Optional

* SwifLint
* SwiftGen
* Fastlane

### Getting started

To get started with the project run `./bootstrap.sh` to install Carthage, SwifLint, SwiftGen, Fastlane and build all the Carthage dependencies. 

If you already have Carthage installed and do not want or need the other tools, just run `carthage bootstrap --platform iOS` to build all the Carthage dependencies. 

This need to be done **just once** for the intial setup.