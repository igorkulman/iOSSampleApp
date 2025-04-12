//
//  ViewControllerLeakTests.swift
//  iOSSampleAppTests
//
//  Created by Igor Kulman on 26/11/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import Foundation
@testable import iOSSampleApp
import XCTest

class ViewControllerLeakTests: XCTestCase {
    func testAboutViewController() {
        let container = setupDependencies()
        let viewController = container.resolve(AboutViewController.self)!
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testLibrariesViewController() {
        let container = setupDependencies()
        let viewController = container.resolve(LibrariesViewController.self)!
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testFeedViewController() {
        let container = setupDependencies()
        let settings = container.resolve(SettingsService.self)!
        settings.selectedSource = RssSource(title: "Test", url: URL(string:"https://blog.kulman.sk")!, rss: URL(string:"https://blog.kulman.sk/index.xml")!, icon: nil)
        let dataService = container.resolve(DataService.self)! as! DataServiceMock
        dataService.result = .success([])
        let viewController = container.resolve(FeedViewController.self)!
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testDetailViewController() {
        let viewController = DetailViewController(item: RssItem(title: "Test", description: "Test sesc", link: URL(string:"https://blog.kulman.sk")!, pubDate: Date()))
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testCustomSourceViewController() {
        let container = setupDependencies()
        let viewController = container.resolve(CustomSourceViewController.self)!
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testSourceSelectionViewController() {
        let container = setupDependencies()
        let viewController = container.resolve(SourceSelectionViewController.self)!
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }
}
