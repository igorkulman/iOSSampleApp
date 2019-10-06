//
//  DataServiceMock.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 16/09/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp

class DataServiceMock: DataService {
    var result: RssResult?

    func getFeed(source: RssSource, onCompletion: @escaping (RssResult) -> Void) {
        onCompletion(result!)
    }
}
