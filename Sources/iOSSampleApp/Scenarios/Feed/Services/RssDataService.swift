//
//  RssDataService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import FeedKit
import Foundation
import OSLog
import UIKit

final class RssDataService: DataService {
    func getFeed(source: RssSource) async throws -> [RssItem] {
        Logger.data.debug("Loading \(source.rss.absoluteString)")
        let feed = try await Feed(url: source.rss)
        switch feed {
        case let .atom(feed):
            guard let entries = feed.entries, !entries.isEmpty else {
                throw RssError.emptyResponse
            }
            return entries.compactMap({ RssItem(item: $0) })
        case let .rss(feed):
            guard let items = feed.channel?.items, !items.isEmpty else {
                throw RssError.emptyResponse
            }
            return items.compactMap({ RssItem(item: $0) })
        case let .json(feed):
            guard let items = feed.items, !items.isEmpty else {
                throw RssError.emptyResponse
            }
            return items.compactMap({ RssItem(item: $0) })
        }
    }
}
