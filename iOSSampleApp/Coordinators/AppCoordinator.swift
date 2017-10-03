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
    private let DASHBOARD_KEY: String = "Dashboard"
    
    // MARK: - Properties
    
    private let window: UIWindow
    let container: Container
    private var childCoordinators = [String: Coordinator]()
    private let settingsService: SettingsService
    
    // MARK: - Coordinator core
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        
        settingsService = self.container.resolve(SettingsService.self)!
    }
    
    func start() {
        if settingsService.isSetupComplete {
            Log.debug?.message("Setup complete, starting dahsboard")
            showDashborad()
        } else {
            Log.debug?.message("Startipng setup")
            showSetup()
        }
    }
    
    private func showDashborad() {
        let dashboardCoordinator = DashboardCoordinator(container: container)
        childCoordinators[DASHBOARD_KEY] = dashboardCoordinator
        //        dashboardCoordinator.delegate = self
        dashboardCoordinator.start()
    }
    
    private func showSetup() {
        let setupCoordinator = SetupCoordinator(container: container, window: window)
        childCoordinators[SETUP_KEY] = setupCoordinator
        setupCoordinator.delegate = self
        setupCoordinator.start()
    }
}

extension AppCoordinator: SetupCoordinatorProtocol {
    func setupCoordinatorDidFinish() {
        showDashborad()
    }
}
