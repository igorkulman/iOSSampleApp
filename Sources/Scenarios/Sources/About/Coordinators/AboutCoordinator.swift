//
//  AboutCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 21/11/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Common
import Foundation
import Operators
import SafariServices
import UIKit

public protocol AboutCoordinatorDelegate: AnyObject {
    /**
     Invoked when the About flow is no longer needed
     */
    func aboutCoordinatorDidFinish()
}

public final class AboutCoordinator: NavigationCoordinator {

    // MARK: - Properties

    public let navigationController: UINavigationController
    public weak var delegate: AboutCoordinatorDelegate?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    /**
     Starts the Abotu flow by showing the basic info and additional menu items
     */
    public func start() {
        let aboutViewController = AboutViewController(viewModel: AboutViewModel()) &> {
            $0.delegate = self
        }
        navigationController.setBackButton()
        navigationController.pushViewController(aboutViewController, animated: true)
    }

    /**
     Shows the list of open source libraries used by the app
     */
    private func showLibraries() {
        let librariesViewController = LibrariesViewController(viewModel: LibrariesViewModel())
        navigationController.pushViewController(librariesViewController, animated: true)
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
        let safariViewController = SFSafariViewController(url: url) &> {
            $0.modalPresentationStyle = .fullScreen
        }
        navigationController.present(safariViewController, animated: true, completion: nil)
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
