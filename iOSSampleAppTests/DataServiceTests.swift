//
//  DataServiceTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
import XCTest
import Nimble
@testable import iOSSampleApp

class DataServiceTests: XCTestCase {

    private let service = RssDataService()

    func testParsingValidFeed() {
        let source = RssSource(title: "Coding Journal", url: "https://blog.kulman.sk", rss: "https://blog.kulman.sk/index.xml", icon: nil)
        waitUntil(timeout: 5) { done in
            self.service.getFeed(source: source) { result in
                expect(result).notTo(equal(.failure(RssError.badUrl)))
                expect(result).to(equal(.success([])))
                done()
            }
        }
    }

    func testParsingInvalidValidFeed() {
        let source = RssSource(title: "Fake", url: "", rss: "", icon: nil)
        waitUntil(timeout: 5) { done in
            self.service.getFeed(source: source) { result in
                expect(result).to(equal(.failure(RssError.badUrl)))
                done()
            }
        }
    }
}
