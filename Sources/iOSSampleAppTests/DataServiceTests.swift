//
//  DataServiceTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 04/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Nimble
import Quick

class DataServiceTests: QuickSpec {
    override func spec() {
        describe("RSS data service") {
            var service: RssDataService!
            beforeEach {
                service = RssDataService()
            }

            context("given valid RSS feed") {
                var source: RssSource!
                beforeEach {
                    source = RssSource(title: "Hacker News", url: URL(string: "https://news.ycombinator.com")!, rss: URL(string: "https://news.ycombinator.com/rss")!, icon: nil)
                }

                it("succeeeds") {
                    waitUntil(timeout: .seconds(5)) { done in
                        service.getFeed(source: source) { result in
                            expect(result).notTo(equal(.failure(RssError.emptyResponse)))
                            expect(result) == .success([])
                            done()
                        }
                    }
                }
            }

            context("given invalid RSS feed") {
                var source: RssSource!
                beforeEach {
                    source = RssSource(title: "Fake", url: URL(string: "https://news.ycombinator.com")!, rss: URL(string: "https://news.ycombinator.com")!, icon: nil)
                }

                it("fails") {
                    waitUntil(timeout: .seconds(5)) { done in
                        service.getFeed(source: source) { result in
                            switch result {
                            case .success:
                                fail("Expected failure, but got success")
                            case .failure:
                                break
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
