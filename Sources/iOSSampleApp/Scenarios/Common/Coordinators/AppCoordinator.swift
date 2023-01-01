//
//  AppCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Swinject
import UIKit

enum AppChildCoordinator {
    case setup
    case feed
}

/**
 Main coordinator responseible for starting the setup process or showing the feed depending on the app state
 */
final class AppCoordinator: Coordinator {

    // MARK: - Properties

    private let window: UIWindow
    let container: Container
    private var childCoordinators = [AppChildCoordinator: Coordinator]()
    private let settingsService: SettingsService
    private let navigationController: UINavigationController

    // MARK: - Coordinator core

    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        navigationController = UINavigationController() &> {
            $0.navigationBar.prefersLargeTitles = true
            $0.navigationBar.isTranslucent = false
            $0.view.backgroundColor = .systemBackground
        }

        settingsService = self.container.resolve(SettingsService.self)!

        self.window.rootViewController = navigationController
    }

    /**
     Starts the app showing either the setup flow or the feed depending on the app state
    */
    func start() {
        if settingsService.selectedSource.isSome {
            Log.debug("Setup complete, starting dashboard")
            showFeed()
        } else {
            Log.debug("Starting setup")
            showSetup()
        }
    }

    /**
     Shows the feed using the FeedCoordinator
     */
    private func showFeed() {
        let feedCoordinator = FeedCoordinator(container: container, navigationController: navigationController) &> {
            $0.delegate = self
        }
        childCoordinators[.feed] = feedCoordinator
        feedCoordinator.start()
    }

    /**
     Starts the setup flow using the SetupCoordinator
     */
    private func showSetup() {
        let setupCoordinator = SetupCoordinator(container: container, navigationController: navigationController) &> {
            $0.delegate = self
        }
        childCoordinators[.setup] = setupCoordinator
        setupCoordinator.start()
    }
}

// MARK: - Delegate

extension AppCoordinator: SetupCoordinatorDelegate {
    /**
     Invoked when the setup flow finishes, setting a RSS source
     */
    func setupCoordinatorDidFinish() {
        childCoordinators[.setup] = nil
        showFeed()
    }
}

extension AppCoordinator: FeedCoordinatorDelegate {
    /**
     Invoked when the feed flow is no longer needed
     */
    func feedCoordinatorDidFinish() {
        childCoordinators[.feed] = nil
        showSetup()
    }
}
