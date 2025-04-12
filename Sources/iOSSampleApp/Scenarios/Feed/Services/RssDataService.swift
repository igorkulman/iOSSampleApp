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
    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void) {
        let parser = FeedParser(URL: source.rss)

        Logger.data.debug("Loading \(source.rss.absoluteString)")

        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case let .success(feed):
                if let rss = feed.rssFeed, let items = rss.items {
                    onCompletion(.success(items.compactMap({ RssItem(item: $0) })))
                    return
                }

                if let atom = feed.atomFeed, let items = atom.entries {
                    onCompletion(.success(items.compactMap({ RssItem(item: $0) })))
                    return
                }

                onCompletion(.failure(RssError.emptyResponse))
            case let .failure(error):
                Logger.data.error("Loading data failed with \(error)")
                onCompletion(.failure(RssError.networkError(error)))
            }
        }
    }
}
