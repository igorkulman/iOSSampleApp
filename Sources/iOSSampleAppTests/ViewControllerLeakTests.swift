//
//  ViewControllerLeakTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 26/11/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import Nimble
import Quick
import SpecLeaks
import Swinject
import XCTest

class ViewControllerLeakTests: QuickSpec {
    override func spec() {
        let container = setupDependencies()

        describe("AboutViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return container.resolve(AboutViewController.self)!
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("LibrariesViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return container.resolve(LibrariesViewController.self)!
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("FeedViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    let settings = container.resolve(SettingsService.self)!
                    settings.selectedSource = RssSource(title: "Test", url: URL(string:"https://blog.kulman.sk")!, rss: URL(string:"https://blog.kulman.sk/index.xml")!, icon: nil)
                    let dataService = container.resolve(DataService.self)! as! DataServiceMock
                    dataService.result = .success([])
                    return container.resolve(FeedViewController.self)!
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("DetailViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return DetailViewController(item: RssItem(title: "Test", description: "Test sesc", link: URL(string:"https://blog.kulman.sk")!, pubDate: Date()))
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("CustomSourceViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return container.resolve(CustomSourceViewController.self)!
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("SourceSelectionViewController") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    return container.resolve(SourceSelectionViewController.self)!
                }
                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }
    }
}
