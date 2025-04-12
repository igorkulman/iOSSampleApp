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
import RxSwift

struct FeedViewModelTests {

    @Test("Load RSS items when initialized")
    func testInitialLoad() throws {
        // Given
        let dataService = DataServiceMock()
        dataService.result = RssResult.success([
            RssItem(title: "Test 1", description: nil, link: URL(string: "https://news.ycombinator.com")!, pubDate: nil),
            RssItem(title: "Test 2", description: nil, link: URL(string: "https://news.ycombinator.com")!, pubDate: nil)
        ])

        let settingsService = SettingsServiceMock()
        settingsService.selectedSource = RssSource(
            title: "Coding Journal",
            url: URL(string: "https://blog.kulman.sk")!,
            rss: URL(string: "https://blog.kulman.sk/index.xml")!,
            icon: nil
        )

        // When
        let vm = FeedViewModel(dataService: dataService, settingsService: settingsService)
        let feed = try vm.feed.toBlocking().first()!

        // Then
        #expect(feed.count == 2)
        #expect(feed[0].title == "Test 1")
        #expect(feed[1].title == "Test 2")
    }
}
