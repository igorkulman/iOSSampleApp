//
//  SetupCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import Foundation
import Swinject
import UIKit

protocol SetupCoordinatorDelegate: AnyObject {
    /**
     Invoked when the setup flow finishes, setting a RSS source
     */
    func setupCoordinatorDidFinish()
}

/**
Setup flow responsible for selecting the RSS source
 */
final class SetupCoordinator: NavigationCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    let container: Container
    weak var delegate: SetupCoordinatorDelegate?

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    /**
     Starts the setup flow asking the user to select the RSS source
     */
    func start() {
        showSourceSelection()
    }

    /**
     Shows the screen asking the user to select the RSS source
     */
    private func showSourceSelection() {
        let vc = container.resolveViewController(SourceSelectionViewController.self)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }

    /**
     Shows the user a screen to add a custom RSS source
     */
    private func showAddSourceForm() {
        let vc = container.resolveViewController(CustomSourceViewController.self)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Delegate

extension SetupCoordinator: SourceSelectionViewControllerDelegate {
    /**
     Invoked when the user finished setting the RSS source
     */
    func sourceSelectionViewControllerDidFinish() {
        delegate?.setupCoordinatorDidFinish()
    }

    /**
     Invoked when user requests adding a new custom source
     */
    func userDidRequestCustomSource() {
        showAddSourceForm()
    }
}

extension SetupCoordinator: CustomSourceViewControllerDelegate {
    /**
     Invokes when user adds a new custom RSS source

     - Parameter source: newly added RSS source
     */
    func userDidAddCustomSource(source: RssSource) {
        if navigationController.viewControllers.count > 1, let sourceSelectionViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? SourceSelectionViewController {
            sourceSelectionViewController.viewModel.addNewSource(source: source)
        }

        navigationController.popViewController(animated: true)
    }
}
