//
//  TestExtensions.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 21/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import XCTest

extension RssResult: Equatable {
    public static func == (lhs: RssResult, rhs: RssResult) -> Bool {
        switch (lhs, rhs) {
        case let (.failure(lerror), .failure(rerror)):
            switch (lerror, rerror) {
            case (RssError.emptyResponse, RssError.emptyResponse):
                return true
            case (RssError.networkError(let lerror), RssError.networkError(let rerror)):
                return lerror.localizedDescription == rerror.localizedDescription
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

extension XCTestCase {
    func assertDeallocatedAfterTest(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance was not deallocated, potential memory leak.", file: file, line: line)
        }
    }
}
