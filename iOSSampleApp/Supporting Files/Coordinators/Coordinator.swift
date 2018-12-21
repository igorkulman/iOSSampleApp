//
//  Coordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Swinject
import UIKit

protocol Coordinator: AnyObject {
    /**
     DI container
     */
    var container: Container { get }

    /**
     Entry point starting the coordinator
     */
    func start()
}

protocol NavigationCoordinator: Coordinator {
    /**
     Navigation controller
     */
    var navigationController: UINavigationController { get }
}
