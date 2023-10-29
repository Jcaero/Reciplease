//
//  LocalRecipeTest.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 29/10/2023.
//

import XCTest
@testable import Reciplease

final class LocalRecipeTest: TestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhenCreateLocaleRecipeWithRecip_LocaleRecipeHaveGoodData() {

        let recipe = LocalRecipe(recipe: mockRecipe)

        XCTAssertEqual(recipe.label, mockRecipe.label)
        XCTAssertEqual(recipe.imageUrl, mockRecipe.images.regular.url)
        XCTAssertEqual(recipe.sourceUrl, mockRecipe.url)
        XCTAssertEqual(recipe.listeOfIngredients, mockRecipe.ingredients)
        XCTAssertEqual(recipe.listeOfIngredientsWithDetail, mockRecipe.ingredientLines)
        XCTAssertEqual(recipe.totalTime, mockRecipe.totalTime)
        XCTAssertEqual(recipe.yield, mockRecipe.yield)
    }
}
