//
//  ServiceProtocols.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RssError: Error, CustomStringConvertible {
    case badUrl

    var description: String {
        switch self {
        case .badUrl:
            return "bad_url".localized
        }
    }
}

enum RssResult {
    case failure(Error)
    case success([RssItem])
}

protocol DataService: class {
    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void)
}

protocol SettingsService: class {
    var selectedSource: RssSource? { get set }
}
