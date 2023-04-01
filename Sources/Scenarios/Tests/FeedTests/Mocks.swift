//
//  File.swift
//  
//
//  Created by Igor Kulman on 01.04.2023.
//

import Common
import Feed
import Foundation

class DataServiceMock: DataService {
  var result: RssResult?

  func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void) {
      onCompletion(result!)
  }
}

class SettingsServiceMock: SettingsService {
    var selectedSource: RssSource?
}
