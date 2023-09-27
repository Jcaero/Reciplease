//
//  RecipleaseUITests.swift
//  RecipleaseUITests
//
//  Created by pierrick viret on 21/09/2023.
//

import XCTest
import Reciplease

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
}
