//
//  FeedViewModelTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 16/09/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Nimble
import Quick
import RxSwift

class FeedViewModelTests: QuickSpec {
    override func spec() {
        describe("FeedViewModel") {
            var dataService: DataServiceMock!
            beforeEach {
                dataService = DataServiceMock()
            }

            context("when initialized") {
                var vm: FeedViewModel!
                beforeEach {
                    dataService.result = RssResult.success([RssItem(title: "Test 1", description: nil, link: URL(string: "https://news.ycombinator.com")!, pubDate: nil), RssItem(title: "Test 2", description: nil, link: URL(string: "https://news.ycombinator.com")!, pubDate: nil)])
                    let settingsService = SettingsServiceMock()
                    settingsService.selectedSource = RssSource(title: "Coding Journal", url: URL(string: "https://blog.kulman.sk")!, rss: URL(string: "https://blog.kulman.sk/index.xml")!, icon: nil)
                    vm = FeedViewModel(dataService: dataService, settingsService: settingsService)
                }

                it("should load RSS items") {
                    let feed = try! vm.feed.toBlocking().first()!
                    expect(feed.count) == 2
                }
            }
        }
    }
}
