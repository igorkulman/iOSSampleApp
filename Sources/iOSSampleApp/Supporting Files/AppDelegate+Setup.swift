//
//  AppDelegate+Setup.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension AppDelegate {
    /**
     Set up the depedency graph in the DI container
     */
    internal func setupDependencies() {
        Log.debug("Registering dependencies")

        // services
        container.autoregister(SettingsService.self, initializer: UserDefaultsSettingsService.init).inObjectScope(ObjectScope.container)
        container.autoregister(DataService.self, initializer: RssDataService.init).inObjectScope(ObjectScope.container)

        // viewmodels
        container.autoregister(SourceSelectionViewModel.self, initializer: SourceSelectionViewModel.init)
        container.autoregister(CustomSourceViewModel.self, initializer: CustomSourceViewModel.init)
        container.autoregister(FeedViewModel.self, initializer: FeedViewModel.init)
        container.autoregister(LibrariesViewModel.self, initializer: LibrariesViewModel.init)
        container.autoregister(AboutViewModel.self, initializer: AboutViewModel.init)

        // view controllers
        container.register(SourceSelectionViewController.self) { r in
            SourceSelectionViewController(viewModel: r~>)
        }
        container.registerViewController(CustomSourceViewController.self) { r, c in
            c.viewModel = r~>
        }
        container.register(FeedViewController.self) { r in
            FeedViewController(viewModel: r~>)
        }
        container.register(LibrariesViewController.self) { r in
            LibrariesViewController(viewModel: r~>)
        }
        container.register(AboutViewController.self) { r in
            AboutViewController(viewModel: r~>)
        }

        #if DEBUG
            if ProcessInfo().arguments.contains("testMode") {
                Log.debug("Running in UI tests, deleting selected source to start clean")
                let settingsService = container.resolve(SettingsService.self)!
                settingsService.selectedSource = nil
            }
        #endif
    }
}
