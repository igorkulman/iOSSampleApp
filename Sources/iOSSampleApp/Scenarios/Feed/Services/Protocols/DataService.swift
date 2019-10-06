//
//  DataService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 20/02/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation

enum RssError: Error, CustomStringConvertible {
    case badUrl

    var description: String {
        switch self {
        case .badUrl:
            return L10n.badUrl
        }
    }
}

enum RssResult {
    case failure(Error)
    case success([RssItem])
}

protocol DataService: AnyObject {
    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void)
}
