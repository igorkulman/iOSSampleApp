//
//  DataService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 20/02/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Common
import Foundation
import Resources

public enum RssError: Error, CustomStringConvertible {
    case badUrl

  public var description: String {
        switch self {
        case .badUrl:
            return L10n.badUrl
        }
    }
}

public enum RssResult {
    case failure(Error)
    case success([RssItem])
}

public protocol DataService: AnyObject {
    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void)
}
