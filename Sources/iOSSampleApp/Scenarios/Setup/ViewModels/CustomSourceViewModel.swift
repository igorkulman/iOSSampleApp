//
//  CustomSourceViewModel.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import Observation

@Observable
final class CustomSourceViewModel {

    // MARK: - Properties

    var title: String?
    var url: String?
    var logoUrl: String?
    var rssUrl: String?

    var isValid: Bool {
        source != nil
    }

    var source: RssSource? {
        guard let title = title, !title.isEmpty,
              let url = url, url.isValidURL, let urlValue = URL(string: url),
              let rssUrl = rssUrl, rssUrl.isValidURL, let rssUrlValue = URL(string: rssUrl) else {
            return nil
        }

        return RssSource(title: title, url: urlValue, rss: rssUrlValue, icon: logoUrl.flatMap({ URL(string: $0) }))
    }
}
