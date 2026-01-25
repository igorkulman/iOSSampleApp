//
//  DataServiceTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import FeedKit
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
        let items = try await service.getFeed(source: source)

        // Then
        #expect(!items.isEmpty)
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

        await #expect(throws: FeedError.unknownFeedFormat) {
            try await service.getFeed(source: source)
        }
    }
}

extension FeedError: @retroactive Equatable {
    public static func == (lhs: FeedError, rhs: FeedError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURLString, .invalidURLString):
            return true
        case (.invalidUtf8String, .invalidUtf8String):
            return true
        case (.unknownFeedFormat, .unknownFeedFormat):
            return true
        case (.invalidHttpResponse(let lCode), .invalidHttpResponse(let rCode)):
            return lCode == rCode
        case (.utf8ConversionFailed, .utf8ConversionFailed):
            return true
        default:
            return true
        }
    }
}
