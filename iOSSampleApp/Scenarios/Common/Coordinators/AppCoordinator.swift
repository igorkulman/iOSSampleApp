//
//  AppCoordinator.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import Foundation
import Swinject
import UIKit

enum AppChildCoordinator {
    case setup
    case feed
}

class AppCoordinator: Coordinator {

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
        navigationController = UINavigationController()

        settingsService = self.container.resolve(SettingsService.self)!

        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.view.backgroundColor = UIColor.white

        self.window.rootViewController = navigationController
    }

    func start() {
        if settingsService.selectedSource != nil {
            Log.debug?.message("Setup complete, starting dahsboard")
            showFeed()
        } else {
            Log.debug?.message("Starting setup")
            showSetup()
        }
    }

    private func showFeed() {
        let feedCoordinator = FeedCoordinator(container: container, navigationController: navigationController)
        childCoordinators[.feed] = feedCoordinator
        feedCoordinator.delegate = self
        feedCoordinator.start()
    }

    private func showSetup() {
        let setupCoordinator = SetupCoordinator(container: container, navigationController: navigationController)
        childCoordinators[.setup] = setupCoordinator
        setupCoordinator.delegate = self
        setupCoordinator.start()
    }
}

// MARK: - Delegate

extension AppCoordinator: SetupCoordinatorDelegate {
    func setupCoordinatorDidFinish() {
        showFeed()
    }
}

extension AppCoordinator: FeedCoordinatorDelegate {
    func feedCoordinatorDidFinish() {
        showSetup()
    }
}
