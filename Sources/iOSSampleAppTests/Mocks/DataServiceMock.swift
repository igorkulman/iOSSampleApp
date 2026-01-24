//
//  DataServiceMock.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 16/09/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation

final class DataServiceMock: DataService {
    var result: RssResult
    var callCount = 0
    var delay: TimeInterval = 0

    init(result: RssResult = .success([
        RssItem(title: "Post 1", description: "Description", link: URL(string: "https://news.ycombinator.com")!, pubDate: Date()),
        RssItem(title: "Post 2", description: "Description", link: URL(string: "https://news.ycombinator.com")!, pubDate: Date()),
        RssItem(title: "Post 3", description: "Description", link: URL(string: "https://news.ycombinator.com")!, pubDate: Date())
    ])) {
        self.result = result
    }

    func getFeed(source: RssSource) async throws -> [RssItem] {
        callCount += 1

        // Simulate network delay if specified
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        switch result {
        case .success(let items):
            return items
        case .failure(let error):
            throw error
        }
    }
}
