//
//  FavoriteSearchControlleur.swift
//  RecipleaseUITests
//
//  Created by pierrick viret on 30/10/2023.
//

import XCTest
@testable import Reciplease

final class FavoriteSearchControlleur: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAppHaveNoSaveRecipe_WhenTapOnFavorite_ShowErreur() throws {

        let app = UIApplication()
        app.launchArguments.append("IS_RUNNING_UITEST")
        app.launch()
        app.tabBarFavorite.tap()
        let expectation = XCTestExpectation(description: "Attente de 2 secondes")
        XCTWaiter().wait(for: [expectation], timeout: 2.0)

        XCTAssertTrue(app.staticTexts["Pas de recette disponible"].exists)
    }

    func testAppHaveSaveRecipe_WhenTapOnFavorite_ShowSaveRecipe() throws {

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
        app.saveButtonStar.tap()

        app.tabBarFavorite.tap()

        XCTAssertTrue(!app.staticTexts["- Tomato"].exists)
    }
}
