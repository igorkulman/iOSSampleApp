//
//  RssSource.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation

public struct RssSource: Codable {
  public init(title: String, url: String, rss: String, icon: String? = nil) {
    self.title = title
    self.url = url
    self.rss = rss
    self.icon = icon
  }

  public let title: String
  public let url: String
  public let rss: String
  public let icon: String?
}

extension RssSource: Equatable {
    public static func == (lhs: RssSource, rhs: RssSource) -> Bool {
        return lhs.rss == rhs.rss
    }
}
