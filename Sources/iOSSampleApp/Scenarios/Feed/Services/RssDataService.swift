//
//  RssDataService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import FeedKit
import Foundation
import os.log
import UIKit

final class RssDataService: DataService {
    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void) {
        guard let feedURL = URL(string: source.rss) else {
            onCompletion(.failure(RssError.badUrl))
            return
        }

        let parser = FeedParser(URL: feedURL)

        os_log("Loading %@", log: OSLog.data, type: .debug, feedURL.absoluteString)

        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case let .success(feed):
                guard let rss = feed.rssFeed, let items = rss.items else {
                    onCompletion(.success([]))
                    return
                }

                onCompletion(.success(items.map({ RssItem(title: $0.title, description: $0.description, link: $0.link, pubDate: $0.pubDate) })))
            case let .failure(error):
                os_log("Loading data failed with %@", log: OSLog.data, type: .error, error as CVarArg)
                onCompletion(.failure(error))
            }
        }
    }
}
