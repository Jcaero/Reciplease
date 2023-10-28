//
//  SearchControlleur.swift
//  RecipleaseUITests
//
//  Created by pierrick viret on 28/10/2023.
//

import XCTest

final class SearchControlleur: XCTestCase {

    func testTextViewIsEmpty_WhenAddIngredient_IngredientIsAdd() {

        let app = UIApplication()
        app.launch()

        app.tabBarSearch.tap()
        app.input.tap()
        app.input.typeText("Tomato")
        app.addButton.tap()

        let expectation = XCTestExpectation(description: "Attente de 2 secondes")
        XCTWaiter().wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(app.staticTexts["- Tomato"].exists)
    }

    func testWhenTextViewAddIngredient_WhenClearButtonTap_TextViewIsClear() {

        let app = UIApplication()
        app.launch()
        app.tabBarSearch.tap()
        app.input.tap()
        app.input.typeText("Tomato")
        app.addButton.tap()
        let expectation = XCTestExpectation(description: "Attente de 2 secondes")
        XCTWaiter().wait(for: [expectation], timeout: 2.0)

        app.clearButton.tap()

        XCTAssertTrue(!app.staticTexts["- Tomato"].exists)
    }
}
