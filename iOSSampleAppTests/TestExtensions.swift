//
//  TestExtensions.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 21/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp

extension RssResult: Equatable {
    public static func == (lhs: RssResult, rhs: RssResult) -> Bool {
        switch (lhs, rhs) {
        case let (.failure(lerror), .failure(rerror)):
            switch (lerror, rerror) {
            case (RssError.badUrl, RssError.badUrl):
                return true
            default:
                return false
            }
        case (.success, .success):
            return true
        default:
            return false
        }
    }

}
