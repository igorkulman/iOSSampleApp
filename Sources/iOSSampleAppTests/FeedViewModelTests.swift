//
//  FeedViewModelTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 16/09/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Testing

struct FeedViewModelTests {

    @Test("Load RSS items when initialized")
    func testInitialLoad() async throws {
        // Given
        let testItems = [
            RssItem(title: "Test 1", description: nil, link: URL(string: "https://news.ycombinator.com")!, pubDate: nil),
            RssItem(title: "Test 2", description: nil, link: URL(string: "https://news.ycombinator.com")!, pubDate: nil)
        ]
        let dataService = DataServiceMock(result: .success(testItems))

        let settingsService = SettingsServiceMock()
        settingsService.selectedSource = RssSource(
            title: "Coding Journal",
            url: URL(string: "https://blog.kulman.sk")!,
            rss: URL(string: "https://blog.kulman.sk/index.xml")!,
            icon: nil
        )

        // When
        let vm = FeedViewModel(dataService: dataService, settingsService: settingsService)
        await vm.load()

        // Then
        #expect(vm.feed.count == 2)
        #expect(vm.feed[0].title == "Test 1")
        #expect(vm.feed[1].title == "Test 2")
    }

    @Test("Handle error when loading feed fails")
    func testLoadError() async throws {
        // Given
        let dataService = DataServiceMock(result: .failure(RssError.emptyResponse))
        let settingsService = SettingsServiceMock()
        settingsService.selectedSource = RssSource(
            title: "Test",
            url: URL(string: "https://example.com")!,
            rss: URL(string: "https://example.com/rss")!,
            icon: nil
        )

        // When
        let vm = FeedViewModel(dataService: dataService, settingsService: settingsService)
        await vm.load()

        // Then
        #expect(vm.feed.isEmpty)
        #expect(vm.error != nil)
        #expect(vm.error is RssError)
    }

    @Test("Clear error when loading succeeds after previous error")
    func testClearErrorOnSuccessfulLoad() async throws {
        // Given
        let dataService = DataServiceMock(result: .failure(RssError.emptyResponse))
        let settingsService = SettingsServiceMock()
        settingsService.selectedSource = RssSource(
            title: "Test",
            url: URL(string: "https://example.com")!,
            rss: URL(string: "https://example.com/rss")!,
            icon: nil
        )

        // When - First load with error
        let vm = FeedViewModel(dataService: dataService, settingsService: settingsService)
        await vm.load()

        // Then
        #expect(vm.error != nil)

        // When - Load again with success
        dataService.result = .success([
            RssItem(title: "Test", description: nil, link: URL(string: "https://example.com")!, pubDate: nil)
        ])
        await vm.load()

        // Then - Error should be cleared
        #expect(vm.error == nil)
        #expect(vm.feed.count == 1)
        #expect(vm.isLoading == false)
    }

    @Test("Handle concurrent load operations safely")
    func testConcurrentLoads() async throws {
        // Given
        let testItems = [
            RssItem(title: "Item 1", description: nil, link: URL(string: "https://example.com")!, pubDate: nil)
        ]
        let dataService = DataServiceMock(result: .success(testItems))
        dataService.delay = 0.05
        let settingsService = SettingsServiceMock()
        settingsService.selectedSource = RssSource(
            title: "Test",
            url: URL(string: "https://example.com")!,
            rss: URL(string: "https://example.com/rss")!,
            icon: nil
        )

        // When - Start multiple loads concurrently
        let vm = FeedViewModel(dataService: dataService, settingsService: settingsService)
        async let load1 = vm.load()
        async let load2 = vm.load()
        async let load3 = vm.load()
        await (load1, load2, load3)

        // Then - State should be consistent
        #expect(vm.feed.count == 1)
        #expect(vm.isLoading == false)
        #expect(dataService.callCount == 4) // 1 from init + 3 from test
    }
}
