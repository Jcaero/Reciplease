//
//  ResulutSearchControllerTest.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 28/10/2023.
//

import XCTest
@testable import Reciplease

final class ResultSearchControllerTest: TestCase {
    // MARK: - Setup Test
    var viewModel: ResultSearchViewModel!

    override func setUp() {
        super.setUp()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testHaveIngredientListeAndNoRecipeCache_WhenfetchRecipe_recipsHaveRecipeAndIsNetworkSuccesfulIsTrue() {

        viewModel = ResultSearchViewModel(repository: NetwokRepositoryMock(mockResult: mockRecipe),
                                          recipesSaveManager: RecipeSaveManagerMock(mockRecipe: nil),
                                          recipeCacheManager: RecipeCacheManagerMock(mockRecipeCached: nil))

        viewModel.fetchInitRecipes(with: ["Lemon", "blueberries"])

        XCTAssertEqual(viewModel.isNetworkSuccessful, true)
        XCTAssertEqual(viewModel.recipes.count, 1)
    }

    func testHaveIngredientListeAndRecipCache_WhenfetchRecipe_recipsHaveRecipeAndIsNetworkSuccesfulIsTrue() {

        viewModel = ResultSearchViewModel(repository: NetwokRepositoryMock(mockResult: nil),
                                          recipesSaveManager: RecipeSaveManagerMock(mockRecipe: nil),
                                          recipeCacheManager: RecipeCacheManagerMock(mockRecipeCached: mockRecipe))

        viewModel.fetchInitRecipes(with: ["Lemon", "blueberries"])

        XCTAssertEqual(viewModel.isNetworkSuccessful, true)
        XCTAssertEqual(viewModel.recipes.count, 1)
    }

    func testHaveIngredientListeAndNoRecipCacheAndNoNetwork_WhenfetchRecipe_AlertHaveMessageAndIsNetworkSuccesfulIsFalse() {

        viewModel = ResultSearchViewModel(repository: NetwokRepositoryMock(mockResult: nil),
                                          recipesSaveManager: RecipeSaveManagerMock(mockRecipe: nil),
                                          recipeCacheManager: RecipeCacheManagerMock(mockRecipeCached: nil))

        viewModel.fetchInitRecipes(with: ["Lemon", "blueberries"])

        XCTAssertEqual(viewModel.isNetworkSuccessful, false)
        XCTAssertEqual(viewModel.alerteMessage?.message, "Erreur de reseau" )
    }

    func testCoreDataHaveRecipe_WhenfetchRecipe_recipsHaveRecipeAndIsNetworkSuccesfulIsTrue() {

        viewModel = ResultSearchViewModel(repository: NetwokRepositoryMock(mockResult: nil),
                                          recipesSaveManager: RecipeSaveManagerMock(mockRecipe: mockRecipe),
                                          recipeCacheManager: RecipeCacheManagerMock(mockRecipeCached: nil))

        viewModel.fetchSaveRecipes()

        XCTAssertEqual(viewModel.isNetworkSuccessful, true)
        XCTAssertEqual(viewModel.recipes.count, 1)
    }
}
