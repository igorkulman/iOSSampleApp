//
//  Swinject+Extensions.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension Container {
    func resolveViewController<ViewController: StoryboardLodable>(_ serviceType: ViewController.Type) -> ViewController {
        let sb = SwinjectStoryboard.create(name: serviceType.storyboardName, bundle: nil, container: self)
        let name = "\(serviceType)".replacingOccurrences(of: "ViewController", with: "")
        return sb.instantiateViewController(withIdentifier: name) as! ViewController
    }
}
