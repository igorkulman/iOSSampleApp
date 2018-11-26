//
//  ViewControllerLeakTests+Setup.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 26/11/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Nimble
import Quick
import Swinject
import XCTest

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
        container.autoregister(DetailViewModel.self, initializer: DetailViewModel.init)
        container.autoregister(LibrariesViewModel.self, initializer: LibrariesViewModel.init)
        container.autoregister(AboutViewModel.self, initializer: AboutViewModel.init)

        // view controllers
        container.storyboardInitCompleted(SourceSelectionViewController.self) { r, c in
            c.viewModel = r.resolve(SourceSelectionViewModel.self)
        }
        container.storyboardInitCompleted(CustomSourceViewController.self) { r, c in
            c.viewModel = r.resolve(CustomSourceViewModel.self)
        }
        container.storyboardInitCompleted(FeedViewController.self) { r, c in
            c.viewModel = r.resolve(FeedViewModel.self)
        }
        container.storyboardInitCompleted(DetailViewController.self) { r, c in
            c.viewModel = r.resolve(DetailViewModel.self)
        }
        container.storyboardInitCompleted(LibrariesViewController.self) { r, c in
            c.viewModel = r.resolve(LibrariesViewModel.self)
        }
        container.storyboardInitCompleted(AboutViewController.self) { r, c
            in c.viewModel = r.resolve(AboutViewModel.self)
        }

        return container
    }
}
