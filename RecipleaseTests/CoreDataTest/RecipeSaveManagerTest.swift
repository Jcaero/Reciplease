//
//  RecipeSaveManagerTest.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 29/10/2023.
//

import XCTest
@testable import Reciplease

final class RecipeSaveManagerTest: TestCase {
    var recipeSaveManager: RecipeSaveManagerProtocol!
    static var needLoad: Bool = true

    override func setUpWithError() throws {
            recipeSaveManager = RecipeSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        if RecipeSaveManagerTest.needLoad {
            CoreDataManagerMock.sharedInstance.load()
            RecipeSaveManagerTest.needLoad = false
        }
    }

    override func tearDownWithError() throws {
        recipeSaveManager = nil
    }

    func testCoreDataHaveRecipe_WhenCallDeleteRecipe_ReturnArrayOfLocalRecipe() {

        recipeSaveManager.saveRecipe(named: LocalRecipe(recipe: mockRecipe), image: mockImage)

        let initRecipe = recipeSaveManager.fetchRecipes()

        recipeSaveManager.deleteAllRecipe()

        let result = recipeSaveManager.fetchRecipes()

        XCTAssertNotNil(initRecipe.count)
        XCTAssertEqual(result.count, 0)
    }

    func testCoreataHaveRecipe_WhenCallFethRecip_ReturnArrayOfLocalRecipe() {
        recipeSaveManager.deleteAllRecipe()
        recipeSaveManager.saveRecipe(named: LocalRecipe(recipe: mockRecipe), image: nil)

        let result = recipeSaveManager.fetchRecipes()

        XCTAssertEqual(result[0].label, mockRecipe.label)
    }

    func testCoreataHaveRecipe_WhenDellRecipe_RecipeIsDell() {
        recipeSaveManager.deleteAllRecipe()
        recipeSaveManager.saveRecipe(named: LocalRecipe(recipe: mockRecipe), image: mockImage)
        recipeSaveManager.saveRecipe(named: LocalRecipe(recipe: mockRecipeTwo), image: mockImage)
        let initCoreDataValue = recipeSaveManager.fetchRecipes()

        recipeSaveManager.deleteRecipe(LocalRecipe(recipe: mockRecipe))

        let result = recipeSaveManager.fetchRecipes()

        XCTAssertEqual(initCoreDataValue.count, 2)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].label, mockRecipeTwo.label)
    }
}
