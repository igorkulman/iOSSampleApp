//
//  iOSSampleAppUITests.swift
//  iOSSampleAppUITests
//
//  Created by Igor Kulman on 23/03/2018.
//  Copyright © 2018 Igor Kulman. All rights reserved.
//

import XCTest

class AppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        XCUIDevice.shared.orientation = .portrait
        setupSnapshot(app)
        app.launchArguments += ["testMode"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testScreenshots() {
        snapshot("1-Setup")

        app.tables.cells.element(boundBy: 1).tap()
        app.buttons["done"].tap()

        snapshot("2-List")

        app.tables.cells.element(boundBy: 0).tap()
        snapshot("3-Detail")

        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons["about"].tap()

        snapshot("4-About")
    }
}
