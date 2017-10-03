//
//  SwinjectStoryboardProtocol.h
//  SwinjectStoryboard
//
//  Created by Mark DiFranco on 2017-05-18.
//  Copyright © 2017 Swinject Contributors. All rights reserved.
//

// Objective-C optional protocol method is used instead of protocol extension to workaround the issue that
// default implementation of a protocol method is always called if a class method conforming the protocol
// is defined as an extension in a different framework.
@protocol SwinjectStoryboardProtocol

@optional
/// Called by Swinject framework once before SwinjectStoryboard is instantiated.
///
/// - Note:
///   Implement this method and setup the default container if you implicitly instantiate UIWindow
///   and its root view controller from "Main" storyboard.
///
/// ```swift
/// extension SwinjectStoryboard {
///     @objc class func setup() {
///         let container = defaultContainer
///         container.register(SomeType.self) {
///             _ in
///             SomeClass()
///         }
///         container.storyboardInitCompleted(ViewController.self) {
///             r, c in
///             c.something = r.resolve(SomeType.self)
///         }
///     }
/// }
/// ```
+ (void)setup;

@end
