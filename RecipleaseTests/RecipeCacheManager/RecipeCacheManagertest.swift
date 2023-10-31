//
//  RecipeCahceManagertest.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 31/10/2023.
//

import XCTest
@testable import Reciplease

final class RecipeCacheManagertest: TestCase {
    var recipeCacheManager: RecipeCacheManagerProtocol!

    override func setUpWithError() throws {
        self.recipeCacheManager = RecipeCacheManager.shared
    }

    override func tearDownWithError() throws {
        self.recipeCacheManager = nil
    }

    func testNoRecipeInCache_WhenSaveRecipe_RecipeIsInCache() {
        recipeCacheManager.save(recipes: [LocalRecipe(recipe: mockRecipe)], nextPage: nil, forKey: "test")

        let (result, _) = recipeCacheManager.getRecipes(for: "test")

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].label, "Blueberry-Lemon")

    }

    func testTwoRecipeInCache_WhenRemoveOne_OnlyOneRecipeInCache() {
        recipeCacheManager.save(recipes: [LocalRecipe(recipe: mockRecipe)], nextPage: nil, forKey: "test")
        recipeCacheManager.save(recipes: [LocalRecipe(recipe: mockRecipeTwo)], nextPage: nil, forKey: "testTwo")
        let (result, _) = recipeCacheManager.getRecipes(for: "test")
        XCTAssertEqual(result.count, 1)

        recipeCacheManager.remove(for: "testTwo")

        let (result2, _) = recipeCacheManager.getRecipes(for: "test")

        XCTAssertEqual(result2.count, 1)
        XCTAssertEqual(result2[0].label, "Blueberry-Lemon")

    }

}
