//
//  DataService.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 20/02/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation

enum RssError: Error, CustomStringConvertible {
    case emptyResponse
    case networkError(Error)

    var description: String {
        switch self {
        case .emptyResponse:
            return String(localized: .emptyResponse)
        case let .networkError(error):
            return error.localizedDescription
        }
    }
}

enum RssResult {
    case failure(RssError)
    case success([RssItem])
}

protocol DataService: AnyObject {
    func getFeed(source: RssSource) async throws -> [RssItem]
}
