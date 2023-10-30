//
//  recipeResultCache.swift
//  Reciplease
//
//  Created by pierrick viret on 22/10/2023.
//

import Foundation
import UIKit

protocol RecipeCacheManagerProtocol {
    func save(recipes: [LocalRecipe], nextPage: String?, forKey ingredients: String)
    func getRecipes(for ingredients: String) -> ([LocalRecipe], String?)
}

struct RecipeCache {
    let recipes: [LocalRecipe]
    let nextPage: String?
}

class RecipeCacheManager: RecipeCacheManagerProtocol {

    // MARK: - Singleton
    static let shared = RecipeCacheManager()

    // MARK: - Propertie
    private let recipeCache = NSCache<NSString, AnyObject>()

    // MARK: - INIT
   private init() {
       recipeCache.countLimit = 50
       recipeCache.totalCostLimit = 50_000_000
    }

    // MARK: - Function
    func save(recipes: [LocalRecipe], nextPage: String?, forKey ingredients: String) {
        let recipe = RecipeCache(recipes: recipes, nextPage: nextPage)
        self.recipeCache.setObject(recipe as AnyObject, forKey: ingredients as NSString)
    }

    func getRecipes(for ingredients: String) -> ([LocalRecipe], String?) {
        if let recipe = recipeCache.object(forKey: ingredients as NSString) as? RecipeCache {
            return (recipe.recipes, recipe.nextPage)
        } else {
            return ([], nil)
        }
    }
}
