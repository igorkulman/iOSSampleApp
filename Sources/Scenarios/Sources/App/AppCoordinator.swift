//
//  AppCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import About
import Common
import Feed
import Foundation
import Operators
import Setup
import UIKit

enum AppChildCoordinator {
    case setup
    case feed
    case about
}

/**
 Main coordinator responseible for starting the setup process or showing the feed depending on the app state
 */
public final class AppCoordinator: Coordinator {

    // MARK: - Properties

    private let window: UIWindow
    private var childCoordinators = [AppChildCoordinator: Coordinator]()
    private let navigationController: UINavigationController
    private let settingsService: SettingsService

    // MARK: - Coordinator core

    public init(window: UIWindow) {
        self.window = window
        settingsService = UserDefaultsSettingsService()

        navigationController = UINavigationController() &> {
            $0.view.backgroundColor = .systemBackground
            $0.navigationBar.prefersLargeTitles = true
            $0.navigationBar.isTranslucent = false
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            $0.navigationBar.standardAppearance = appearance
            $0.navigationBar.scrollEdgeAppearance = $0.navigationBar.standardAppearance
        }

        self.window.rootViewController = navigationController
    }

    /**
     Starts the app showing either the setup flow or the feed depending on the app state
    */
  public func start() {
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
        let feedCoordinator = FeedCoordinator(navigationController: navigationController, settingsService: settingsService) &> {
            $0.delegate = self
        }
        childCoordinators[.feed] = feedCoordinator
        feedCoordinator.start()
    }

    /**
     Starts the setup flow using the SetupCoordinator
     */
    private func showSetup() {
        let setupCoordinator = SetupCoordinator(navigationController: navigationController, settingsService: settingsService) &> {
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
  public func setupCoordinatorDidFinish() {
        childCoordinators[.setup] = nil
        showFeed()
    }
}

extension AppCoordinator: FeedCoordinatorDelegate {
    /**
     Invoked when user requests showing the About screen
     */
    public func usedDidRequestAbout() {
        let aboutCoordinator = AboutCoordinator(navigationController: navigationController) &> {
            $0.delegate = self
        }
        childCoordinators[.about] = aboutCoordinator
        aboutCoordinator.start()
    }

    /**
     Invoked when the feed flow is no longer needed
     */
    public func feedCoordinatorDidFinish() {
        childCoordinators[.feed] = nil
        showSetup()
    }
}

extension AppCoordinator: AboutCoordinatorDelegate {
    /**
     Invoked when the About flow is no longer needed
     */
    public func aboutCoordinatorDidFinish() {
        childCoordinators[.about] = nil
    }
}
