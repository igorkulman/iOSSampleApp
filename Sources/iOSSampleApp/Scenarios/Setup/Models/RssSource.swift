//
//  RssSource.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

struct RssSource: Codable {
    let title: String
    let url: URL
    let rss: URL
    let icon: URL?
}

extension RssSource: Equatable {
    static func == (lhs: RssSource, rhs: RssSource) -> Bool {
        return lhs.rss == rhs.rss
    }
}
