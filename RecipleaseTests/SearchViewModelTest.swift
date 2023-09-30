//
//  SearchViewModelTest.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 30/09/2023.
//

import XCTest
@testable import Reciplease

final class SearchViewModelTest: XCTestCase {
    // MARK: - Setup Test
    var viewModel: SearchViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    // MARK: - Test for add Ingredient
    func testIngredientListeIsEmpty_WhenAddLemon_IngredientListeHaveLemon() {
        viewModel.addIngredient("Lemon")

        XCTAssertEqual(viewModel.ingredientList, "- Lemon")
    }

    func testIngredientListeHaveLemon_WhenAddCheese_IngredientListeHaveLemonAndCheese() {
        viewModel.addIngredient("Lemon")

        viewModel.addIngredient("Cheese")

        let result = """
        - Lemon
        - Cheese
        """
        XCTAssertEqual(viewModel.ingredientList, result)
    }

    func testIngredientListeHaveLemon_WhenAddLemon_IngredientListeNotChange() {
        viewModel.addIngredient("Lemon")

        viewModel.addIngredient("Lemon")

        XCTAssertEqual(viewModel.ingredientList, "- Lemon")
    }

    // MARK: - Test for clear Ingredient

    func testIngredientListeHaveLemonAndCheese_WhenClear_IngredientListeIsEmpty() {
        viewModel.addIngredient("Lemon")
        viewModel.addIngredient("Cheese")

        viewModel.clearIngredientList()

        XCTAssertEqual(viewModel.ingredientList, "")
    }
}
