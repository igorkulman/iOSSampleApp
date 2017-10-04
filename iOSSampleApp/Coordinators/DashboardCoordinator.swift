//
//  DashboardCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit
import CleanroomLogger
import Swinject

class DashboardCoordinator: NavigationCoordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    let container: Container
    
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator core
    
    func start() {
        let isTransitionFromSetup = navigationController.viewControllers.count > 0
        let vc = container.resolveViewController(DashboardViewController.self)
        vc.navigationItem.hidesBackButton = true
        navigationController.pushViewController(vc, animated: true)
        if isTransitionFromSetup {
            navigationController.viewControllers.remove(at: 0)
        }
    }
    
}
