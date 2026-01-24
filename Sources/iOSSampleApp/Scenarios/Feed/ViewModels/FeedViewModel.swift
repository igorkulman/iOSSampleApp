//
//  DashboardViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Observation
import UIKit

@Observable
final class FeedViewModel {

    // MARK: - Properties

    /**
     Current feed items
     */
    private(set) var feed: [RssItem] = []

    /**
     Most recent error from feed refresh
     */
    private(set) var error: Error?

    /**
     Indicates if feed is currently loading
     */
    private(set) var isLoading = false

    /**
     Feed title
     */
    let title: String

    // MARK: - Fields

    private let dataService: DataService
    private let source: RssSource
    private var foregroundObserver: NSObjectProtocol?

    init(dataService: DataService, settingsService: SettingsService) {
        guard let source = settingsService.selectedSource else {
            fatalError("Source not selected, nothing to show in feed")
        }

        self.dataService = dataService
        self.source = source
        self.title = source.title

        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task {
                await self?.load()
            }
        }

        Task {
            await load()
        }
    }

    deinit {
        if let observer = foregroundObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Methods

    func clearError() {
        error = nil
    }

    @MainActor
    func load() async {
        isLoading = true
        error = nil

        do {
            let items = try await dataService.getFeed(source: source)
            feed = items
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
