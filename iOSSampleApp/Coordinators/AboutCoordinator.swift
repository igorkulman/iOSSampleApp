//
//  AboutCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit
import Swinject

protocol AboutCoordinatorDelegate: class {
    func aboutCoordinatorDidFinish()
}

class AboutCoordinator: NavigationCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    let container: Container
    weak var delegate: AboutCoordinatorDelegate?

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    func start() {
        let vc = container.resolveViewController(AboutViewController.self)
        vc.delegate = self
        navigationController.setBackButton()
        navigationController.pushViewController(vc, animated: true)
    }

    private func showLibraries() {
        let vc = container.resolveViewController(LibrariesViewController.self)
        navigationController.pushViewController(vc, animated: true)
    }

    private func showAuthorsInfo() {
    }

    private func showAuthorsBlog() {
    }
}

extension AboutCoordinator: AboutViewControllerDelegate {
    func userDidRequestAuthorsBlog() {
        showAuthorsBlog()
    }

    func userDidRequestAuthorsInfo() {
        showAuthorsInfo()
    }

    func userDidRequestLibraries() {
        showLibraries()
    }

    func aboutViewControllerDismissed() {
        delegate?.aboutCoordinatorDidFinish()
    }
}
