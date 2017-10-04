//
//  StoryboardLodable.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardLodable: class {
    @nonobjc static var storyboardName: String { get }
}

protocol SetupStoryboardLodable: StoryboardLodable {
}

protocol FeedStoryboardLodable: StoryboardLodable {
}

extension SetupStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Setup"
    }
}

extension FeedStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Feed"
    }
}
