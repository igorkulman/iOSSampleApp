//
//  DashboardCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Common
import Foundation
import Operators
import UIKit

public protocol FeedCoordinatorDelegate: AnyObject {
    /**
     Invoked when the feed flow is no longer needed
     */
    func feedCoordinatorDidFinish()

    /**
     Invoked when user requests showing the About screen
     */
    func usedDidRequestAbout()
}

public final class FeedCoordinator: NavigationCoordinator {

    // MARK: - Properties

    public let navigationController: UINavigationController
    public weak var delegate: FeedCoordinatorDelegate?

    private let dataService: DataService
    private let settingsService: SettingsService

    public init(navigationController: UINavigationController, settingsService: SettingsService) {
        self.navigationController = navigationController
        self.dataService = RssDataService()
        self.settingsService = settingsService
    }

    // MARK: - Coordinator core

    /**
     Starts the feed flow showing the list of articles from the currently selected RSS source
     */
    public func start() {
        let isNavigationStackEmpty = navigationController.viewControllers.isEmpty
        let feedViewController = FeedViewController(viewModel: FeedViewModel(dataService: dataService, settingsService: settingsService)) &> {
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
      delegate?.usedDidRequestAbout()
    }
}

// MARK: - Delegate

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
