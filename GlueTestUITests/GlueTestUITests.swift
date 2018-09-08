//
//  GlueTestUITests.swift
//  GlueTestUITests
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import XCTest

class GlueTestUITests: XCTestCase {
    
    let fileManager = FileManager.default
    
    override func setUp()
    {
        super.setUp()
        continueAfterFailure = false
       
        let app = XCUIApplication()
        app.launchArguments = ["UITestMode"]
        app.launch()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func test_tappingCellSearchesByGenre()
    {
        XCTAssertEqual(XCUIApplication().collectionViews.cells.count, 15)
        XCUIApplication().collectionViews.cells.children(matching: .other).element(boundBy: 0).tap()
        XCTAssertNotEqual(XCUIApplication().collectionViews.cells.count, 15)
    }
    
    func test_enteringTextSearchesByTitle()
    {
        XCTAssertEqual(XCUIApplication().collectionViews.cells.count, 15)
        XCUIApplication().searchFields["Search"].tap()
        XCUIApplication().searchFields["Search"].typeText("Fan")
        XCTAssertNotEqual(XCUIApplication().collectionViews.cells.count, 15)
    }
}
