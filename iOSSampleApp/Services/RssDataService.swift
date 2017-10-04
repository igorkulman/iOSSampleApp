//
//  RssDataService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import FeedKit
import CleanroomLogger
import UIKit

class RssDataService: DataService {
    func getFeed(source: RssSource, onCompletion: @escaping ([RssItem]) -> Void) {
        if let feedURL = URL(string: source.rss), let parser = FeedParser(URL: feedURL) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            Log.debug?.message("Loading \(feedURL)")

            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
                if let rss = result.rssFeed, let items = rss.items {
                    onCompletion(items.map({ RssItem(title: $0.title, description: $0.description, link: $0.link, pubDate: $0.pubDate) }))
                } else {
                    onCompletion([])
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        } else {
            onCompletion([])
        }
    }
}
