//
//  DashboardCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import UIKit

enum FeedChildCoordinator {
    case about
}

protocol FeedCoordinatorDelegate: AnyObject {
    /**
     Invoked when the feed flow is no longer needed
     */
    func feedCoordinatorDidFinish()
}

final class FeedCoordinator: NavigationCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    private let container: Container
    private var childCoordinators = [FeedChildCoordinator: Coordinator]()

    weak var delegate: FeedCoordinatorDelegate?

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    /**
     Starts the feed flow showing the list of articles from the currently selected RSS source
     */
    func start() {
        let isNavigationStackEmpty = navigationController.viewControllers.isEmpty
        let feedViewController = container.makeFeedViewController() &> {
            $0.delegate = self
            $0.navigationItem.hidesBackButton = true
        }
        navigationController.pushViewController(feedViewController, animated: true)

        // FeedViewController should be always the top most VC
        if !isNavigationStackEmpty {
            navigationController.viewControllers.remove(at: 0)
        }
    }

    /**
     Shows RSS item detail in a separate modal screen

     - Parameter item: RSS item to show detail
     */
    private func showDetail(item: RssItem) {
        let detailViewController = DetailViewController(item: item) &> {
            $0.delegate = self
        }
        let internalNavigationController = UINavigationController(rootViewController: detailViewController) &> {
            $0.modalPresentationStyle = .fullScreen
        }
        navigationController.present(internalNavigationController, animated: true, completion: nil)
    }

    /**
     Shows the About screen by starting the AboutCoordinator
     */
    private func showAbout() {
        let aboutCoordinator = AboutCoordinator(container: container, navigationController: navigationController) &> {
            $0.delegate = self
        }
        childCoordinators[.about] = aboutCoordinator
        aboutCoordinator.start()
    }
}

// MARK: - Delegate

extension FeedCoordinator: AboutCoordinatorDelegate {
    /**
     Invoked when the About flow is no longer needed
     */
    func aboutCoordinatorDidFinish() {
        childCoordinators[.about] = nil
    }
}

extension FeedCoordinator: FeedViewControllerDelegeate {
    /**
     Invoked when user resuests the About screen
     */
    func userDidRequestAbout() {
        showAbout()
    }

    /**
     Invoked when user requests starting the setup process again
     */
    func userDidRequestSetup() {
        delegate?.feedCoordinatorDidFinish()
    }

    /**
     Invoked when user requests showing RSS item detail

     - Parameter item: RSS item to show detail
     */
    func userDidRequestItemDetail(item: RssItem) {
        showDetail(item: item)
    }
}

extension FeedCoordinator: DetailViewControllerDelegate {
    /**
     Invoked when user finished looking at the RSS source detail
     */
    func detailViewControllerDidFinish() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
