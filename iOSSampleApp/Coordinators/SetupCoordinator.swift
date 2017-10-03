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

protocol SetupCoordinatorDelegate: class {
    func setupCoordinatorDidFinish()
}

class SetupCoordinator: NavigationCoordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    let container: Container
    weak var delegate: SetupCoordinatorDelegate?
    
    // MARK: - Fields
    
    private let window: UIWindow
    
    init(container: Container, window: UIWindow){
        self.container = container
        self.window = window
        navigationController = UINavigationController()
        navigationController.adjust()
        
        self.window.rootViewController = navigationController
    }
    
    // MARK: - Coordinator core
    
    func start() {
        showSourceSelection()
    }
    
    private func showSourceSelection() {
        let vc = container.resolveViewController(SourceSelectionViewController.self)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showAddSourceForm() {
        let vc = container.resolveViewController(CustomSourceViewController.self)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension SetupCoordinator: SourceSelectionViewControllerDelegate {
    func sourceSelectionViewControllerDidFinish() {
        delegate?.setupCoordinatorDidFinish()
    }
    
    func userDidRequestCustomSource() {
        showAddSourceForm()
    }
}

extension SetupCoordinator: CustomSourceViewControllerDelegate {
    func userDidAddCustomSource() {        
        navigationController.popViewController(animated: true)
    }
}
