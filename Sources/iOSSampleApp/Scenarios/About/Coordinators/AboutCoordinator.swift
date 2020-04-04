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
    /**
     Invoked when the About flow is no longer needed
     */
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

    /**
     Starts the Abotu flow by showing the basic info and additional menu items
     */
    func start() {
        let vc = container.resolve(AboutViewController.self)!
        vc.delegate = self
        navigationController.setBackButton()
        navigationController.pushViewController(vc, animated: true)
    }

    /**
     Shows the list of open source libraries used by the app
     */
    private func showLibraries() {
        let vc = container.resolve(LibrariesViewController.self)!
        navigationController.pushViewController(vc, animated: true)
    }

    /**
     Shows the authors info in SafariVC
     */
    private func showAuthorsInfo() {
        showUrl(url: "https://blog.kulman.sk/about/")
    }

    /**
     Shows the authors blog in SafariVC
     */
    private func showAuthorsBlog() {
        showUrl(url: "https://blog.kulman.sk")
    }

    /**
     Shows provided URL in SafariVC

     - Parameter url: URL to show
     */
    private func showUrl(url: URL) {
        let svc = SFSafariViewController(url: url)
        svc.modalPresentationStyle = .fullScreen
        navigationController.present(svc, animated: true, completion: nil)
    }
}

// MARK: - Delegate

extension AboutCoordinator: AboutViewControllerDelegate {
    /**
     Invoked when user requests the authors blog
     */
    func userDidRequestAuthorsBlog() {
        showAuthorsBlog()
    }

    /**
     Invoked when user requests the authors info
     */
    func userDidRequestAuthorsInfo() {
        showAuthorsInfo()
    }

    /**
     Invoked when user requests the list of used open source libraries
     */
    func userDidRequestLibraries() {
        showLibraries()
    }

    /**
     Invoked when user naviages back from the About screen
     */
    func aboutViewControllerDismissed() {
        delegate?.aboutCoordinatorDidFinish()
    }
}
