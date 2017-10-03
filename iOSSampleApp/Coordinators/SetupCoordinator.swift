//
//  SetupCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit
import CleanroomLogger
import Swinject

class SetupCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    let container: Container
    private let window: UIWindow
    
    init(container: Container, window: UIWindow){
        self.container = container
        self.window = window
        navigationController = UINavigationController()
        navigationController.adjust()
        
        self.window.rootViewController = navigationController
    }
    
    func start() {
        showSourceSelection()
    }
    
    private func showSourceSelection() {
        let vc = container.resolveViewController(SourceSelectionViewController.self)
        //vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showAddSourceForm() {
        
    }
}
