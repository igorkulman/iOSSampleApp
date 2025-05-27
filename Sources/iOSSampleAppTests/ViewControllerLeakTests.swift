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
    private lazy var container = Container() &> {
        $0.settingsService = SettingsServiceMock()
        $0.dataService = DataServiceMock()
    }

    func testAboutViewController() {
        let viewController = container.makeAboutViewController()
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testLibrariesViewController() {
        let viewController = container.makeLibrariesViewController()
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testFeedViewController() {
        container.settingsService.selectedSource = RssSource(title: "Test", url: URL(string:"https://blog.kulman.sk")!, rss: URL(string:"https://blog.kulman.sk/index.xml")!, icon: nil)
        let dataService = container.dataService as! DataServiceMock
        dataService.result = .success([])
        let viewController = container.makeFeedViewController()
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testDetailViewController() {
        let viewController = DetailViewController(item: RssItem(title: "Test", description: "Test sesc", link: URL(string:"https://blog.kulman.sk")!, pubDate: Date()))
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testCustomSourceViewController() {
        let viewController = container.makeCustomSourceViewController()
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }

    func testSourceSelectionViewController() {
        let viewController = container.makeSourceSelectionViewController()
        assertDeallocatedAfterTest(viewController)
        viewController.loadViewIfNeeded()
    }
}
