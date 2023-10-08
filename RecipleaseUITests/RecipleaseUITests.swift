//
//  RecipleaseUITests.swift
//  RecipleaseUITests
//
//  Created by pierrick viret on 21/09/2023.
//

import XCTest
@testable import Reciplease

private extension XCUIApplication {
    var addButton: XCUIElement {self.buttons["Add"]}
    var searchButton: XCUIElement {self.buttons["searchButton"]}
    var input: XCUIElement {self.searchFields["inputTextFields"]}
    var tabBarSearch: XCUIElement {tabBars.buttons.element(boundBy: 0)}
}

final class AccessibilityTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testAccessibility() throws {
                // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        try app.performAccessibilityAudit()
    }

    func testAccessibilityTableView() throws {
                // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tabBarSearch.tap()
        app.input.tap()
        app.input.typeText("Tomato")
        app.addButton.tap()
        app.searchButton.tap()
        try app.performAccessibilityAudit()
    }
}
