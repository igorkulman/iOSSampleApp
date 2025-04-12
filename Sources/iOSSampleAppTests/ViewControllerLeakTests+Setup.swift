//
//  ViewControllerLeakTests+Setup.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 26/11/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Swinject
import SwinjectAutoregistration

extension ViewControllerLeakTests {
    func setupDependencies() -> Container {
        let container = Container()

        // services
        container.autoregister(SettingsService.self, initializer: SettingsServiceMock.init).inObjectScope(ObjectScope.container)
        container.autoregister(DataService.self, initializer: DataServiceMock.init).inObjectScope(ObjectScope.container)

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
        container.register(CustomSourceViewController.self) { r in
            CustomSourceViewController(viewModel: r~>)
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

        return container
    }
}
