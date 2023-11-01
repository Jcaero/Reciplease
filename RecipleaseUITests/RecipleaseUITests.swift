//
//  RecipleaseUITests.swift
//  RecipleaseUITests
//
//  Created by pierrick viret on 21/09/2023.
//

import XCTest
@testable import Reciplease

final class AccessibilityTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testAccessibility() throws {

        let app = XCUIApplication()
        app.launch()
        try app.performAccessibilityAudit()
    }

    // Test TableView without clipped : ingredients liste is normally clipped
    func testAccessibilityTableView() throws {

        let app = UIApplication()
        app.launch()
        app.tabBarSearch.tap()
        app.input.tap()
        app.input.typeText("Tomato")
        app.addButton.tap()
        app.searchButton.tap()
        let expectation = XCTestExpectation(description: "Attente de 3 secondes")
        XCTWaiter().wait(for: [expectation], timeout: 5.0)
        try app.performAccessibilityAudit(for: .all.subtracting(.textClipped))
    }

    // Test TableView without clipped : ingredients liste is normally clipped
    func testAccessibilityTableViewDetail() throws {

        let app = UIApplication()
        app.launch()
        app.tabBarSearch.tap()
        app.input.tap()
        app.input.typeText("Tomato")
        app.addButton.tap()
        app.searchButton.tap()
        let expectation = XCTestExpectation(description: "Attente de 5 secondes")
        XCTWaiter().wait(for: [expectation], timeout: 5.0)
        app.cells["Tomato Gravy"].tap()
        try app.performAccessibilityAudit(for: .all.subtracting(.textClipped))
    }
}
