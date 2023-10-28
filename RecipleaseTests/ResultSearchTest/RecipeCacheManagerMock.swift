//
//  RecipeCacheManagerMock.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 28/10/2023.
//

import Foundation
import UIKit

@testable import Reciplease

class RecipeCacheManagerMock: RecipeCacheManagerProtocol {

    private var mockRecipe: Recipe?

    init(mockRecipeCached: Recipe?) {
        self.mockRecipe = mockRecipeCached
    }

    func save(recipes: [Reciplease.LocalRecipe], forKey ingredients: String) {
    }

    func getRecipes(for ingredients: String) -> [Reciplease.LocalRecipe] {
        guard let mockRecipe = mockRecipe else { return [] }
        return [LocalRecipe(recipe: mockRecipe)]
    }
}
