//
//  RssDataService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import FeedKit
import Foundation
import UIKit

class RssDataService: DataService {
    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void) {
        guard let feedURL = URL(string: source.rss) else {
            onCompletion(.failure(RssError.badUrl))
            return
        }

        let parser = FeedParser(URL: feedURL)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Log.debug?.message("Loading \(feedURL)")

        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            if let error = result.error {
                onCompletion(.failure(error))
            } else if let rss = result.rssFeed, let items = rss.items {
                onCompletion(.success(items.map({ RssItem(title: $0.title, description: $0.description, link: $0.link, pubDate: $0.pubDate) })))
            } else {
                onCompletion(.success([]))
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
