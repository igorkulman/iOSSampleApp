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

protocol DataService: class {
    func getFeed(source: RssSource, onCompletion: @escaping ([RssItem]) -> Void)
}

protocol SettingsService: class {
    var selectedSource: RssSource? { get set }
}
