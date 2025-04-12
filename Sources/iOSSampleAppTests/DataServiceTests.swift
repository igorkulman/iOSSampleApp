//
//  DataServiceTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Testing

struct DataServiceTests {

    @Test("Successfully fetch from valid RSS feed")
    func testValidRssFeed() async throws {
        // Given
        let service = RssDataService()
        let source = RssSource(
            title: "Hacker News",
            url: URL(string: "https://news.ycombinator.com")!,
            rss: URL(string: "https://news.ycombinator.com/rss")!,
            icon: nil
        )

        // When
        let result = await withCheckedContinuation { continuation in
            service.getFeed(source: source) { result in
                continuation.resume(returning: result)
            }
        }

        // Then
        switch result {
        case let .success(items):
            #expect(!items.isEmpty)
        case let .failure(error):
            Issue.record("Failed with error: \(error)")
        }
    }

    @Test("Fail when fetching from invalid RSS feed")
    func testInvalidRssFeed() async throws {
        // Given
        let service = RssDataService()
        let source = RssSource(
            title: "Fake",
            url: URL(string: "https://news.ycombinator.com")!,
            rss: URL(string: "https://news.ycombinator.com")!,
            icon: nil
        )

        // When
        let result = await withCheckedContinuation { continuation in
            service.getFeed(source: source) { result in
                continuation.resume(returning: result)
            }
        }

        // Then
        switch result {
        case .success:
            Issue.record("Expected failure but got success")
        case .failure:
            break
        }
    }
}
