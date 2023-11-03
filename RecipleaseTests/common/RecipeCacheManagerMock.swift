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
    func remove(for ingredients: String) {
    }

    private var mockRecipe: Recipe?

    init(mockRecipeCached: Recipe?) {
        self.mockRecipe = mockRecipeCached
    }

    func save(recipes: [Reciplease.LocalRecipe], nextPage: String?, forKey ingredients: String) {
    }

    func getRecipes(for ingredients: String) -> ([Reciplease.LocalRecipe], String?) {
        guard let mockRecipe = mockRecipe else { return ([], nil) }
        return ([LocalRecipe(recipe: mockRecipe)], "https://nextPage")
    }
}
