//
//  AppContainer.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 27.05.2025.
//  Copyright © 2025 Igor Kulman. All rights reserved.
//

import Foundation
import OSLog

final class Container {

    init() {
        Logger.appFlow.debug("Registering dependencies")
        #if DEBUG
        if ProcessInfo().arguments.contains("testMode") {
            Logger.appFlow.debug("Running in UI tests, deleting selected source to start clean")
            settingsService.selectedSource = nil
        }
        #endif
    }

    // MARK: - Services

    lazy var dataService: DataService = RssDataService()
    lazy var settingsService: SettingsService = UserDefaultsSettingsService()

    // MARK: - ViewModels

    func makeSourceSelectionViewModell() -> SourceSelectionViewModel {
        SourceSelectionViewModel(settingsService: settingsService)
    }

    func makeCustomSourceViewModel() -> CustomSourceViewModel {
        CustomSourceViewModel()
    }

    func makeFeedViewModel() -> FeedViewModel {
        FeedViewModel(dataService: dataService, settingsService: settingsService)
    }

    func makeLibrariesViewModel() -> LibrariesViewModel {
        LibrariesViewModel()
    }

    func makeAboutViewModel() -> AboutViewModel {
        AboutViewModel()
    }

    // MARK: - ViewControllers

    func makeSourceSelectionViewController() -> SourceSelectionViewController {
        SourceSelectionViewController(viewModel: makeSourceSelectionViewModell())
    }

    func makeCustomSourceViewController() -> CustomSourceViewController {
        CustomSourceViewController(viewModel: makeCustomSourceViewModel())
    }

    func makeFeedViewController() -> FeedViewController {
        FeedViewController(viewModel: makeFeedViewModel())
    }

    func makeLibrariesViewController() -> LibrariesViewController {
        LibrariesViewController(viewModel: makeLibrariesViewModel())
    }

    func makeAboutViewController() -> AboutViewController {
        AboutViewController(viewModel: makeAboutViewModel())
    }
}
