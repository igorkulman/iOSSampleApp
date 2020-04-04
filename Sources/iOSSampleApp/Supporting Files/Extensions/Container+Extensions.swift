//
//  Swinject+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Swinject
import UIKit

extension Container {
    @discardableResult
    func registerViewController<ViewController: StoryboardLodable>(_ controllerType: ViewController.Type, initCompleted: ((Swinject.Resolver, ViewController) -> Void)?  = nil) -> Swinject.ServiceEntry<ViewController> {
        return register(ViewController.self) { r in
            let storyboard = UIStoryboard(name: controllerType.storyboardName, bundle: nil)
            let name = "\(controllerType)".replacingOccurrences(of: "ViewController", with: "")
            let viewController = storyboard.instantiateViewController(withIdentifier: name) as! ViewController
            initCompleted?(r, viewController)
            return viewController
        }
    }
}
