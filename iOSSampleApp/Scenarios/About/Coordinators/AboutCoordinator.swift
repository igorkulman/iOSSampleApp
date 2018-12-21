//
//  AboutCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import SafariServices
import Swinject
import UIKit

protocol AboutCoordinatorDelegate: AnyObject {
    func aboutCoordinatorDidFinish()
}

final class AboutCoordinator: NavigationCoordinator {

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
        showUrl(url: "https://blog.kulman.sk/about/")
    }

    private func showAuthorsBlog() {
        showUrl(url: "https://blog.kulman.sk")
    }

    private func showUrl(url: String) {
        let svc = SFSafariViewController(url: URL(string: url)!)
        navigationController.present(svc, animated: true, completion: nil)
    }
}

// MARK: - Delegate

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
