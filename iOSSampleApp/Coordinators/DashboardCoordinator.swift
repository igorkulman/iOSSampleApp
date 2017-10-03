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
    
    init(container: Container) {
        self.container = container
        navigationController = UINavigationController()
        navigationController.adjust()
    }
    
    // MARK: - Coordinator core
    
    func start() {
        
    }
    
}
