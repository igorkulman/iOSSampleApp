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
import CleanroomLogger

class AppCoordinator: Coordinator {
    
    // MARK: - Coordinator keys
    
    private let SETUP_KEY: String = "Setup"
    private let FEED_KEY: String = "Feed"
    
    // MARK: - Properties
    
    private let window: UIWindow
    let container: Container
    private var childCoordinators = [String: Coordinator]()
    private let settingsService: SettingsService
    private let navigationController: UINavigationController
    
    // MARK: - Coordinator core
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        self.navigationController = UINavigationController()
        
        self.settingsService = self.container.resolve(SettingsService.self)!
        
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.view.backgroundColor = UIColor.white
        
        self.window.rootViewController = self.navigationController
    }
    
    func start() {
        if settingsService.selectedSource != nil {
            Log.debug?.message("Setup complete, starting dahsboard")
            showFeed()
        } else {
            Log.debug?.message("Startipng setup")
            showSetup()
        }
    }
    
    private func showFeed() {
        let feedCoordinator = FeedCoordinator(container: container, navigationController: navigationController)
        childCoordinators[FEED_KEY] = feedCoordinator
        feedCoordinator.start()
    }
    
    private func showSetup() {
        let setupCoordinator = SetupCoordinator(container: container, navigationController: navigationController)
        childCoordinators[SETUP_KEY] = setupCoordinator
        setupCoordinator.delegate = self
        setupCoordinator.start()
    }
}

extension AppCoordinator: SetupCoordinatorDelegate {
    func setupCoordinatorDidFinish() {
        showFeed()
    }
}
