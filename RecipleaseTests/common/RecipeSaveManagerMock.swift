//
//  RecipeSaveManagerMock.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 28/10/2023.
//

import Foundation
import UIKit

@testable import Reciplease

final class RecipeSaveManagerMock: RecipeSaveManagerProtocol {

    private var mockRecipe: Recipe?

    init(mockRecipe: Recipe?) {
        self.mockRecipe = mockRecipe
    }

    func saveRecipe(named recipe: LocalRecipe, image: UIImage?) {
    }

    func fetchRecipes() -> [LocalRecipe] {
        guard let mockRecipe = mockRecipe else { return [] }
        return [LocalRecipe(recipe: mockRecipe)]
    }

    func deleteRecipe( _ recipe: LocalRecipe) {
    }

    func isSaveRecipeContains(_ recipe: LocalRecipe) -> Bool {
        guard let mockRecipe = mockRecipe else { return false }
        return recipe.label == mockRecipe.label ? true : false
    }

    func deleteAllRecipe() {
    }
}
