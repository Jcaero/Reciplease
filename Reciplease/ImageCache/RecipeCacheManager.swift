//
//  recipeResultCache.swift
//  Reciplease
//
//  Created by pierrick viret on 22/10/2023.
//

import Foundation
import UIKit

class RecipeCacheManager {

    // MARK: - Singleton
    static let shared = RecipeCacheManager()

    // MARK: - Propertie
    private let recipeCache = NSCache<NSString, NSArray>()

    // MARK: - INIT
   private init() {
       recipeCache.countLimit = 50
       recipeCache.totalCostLimit = 50 * 1024 * 1024
    }

    // MARK: - Function
    func save(recipes: [LocalRecipe], forKey ingredients: String) {
        self.recipeCache.setObject(recipes as NSArray, forKey: ingredients as NSString)
    }

    func getRecipes(for ingredients: String) -> [LocalRecipe] {
        return (recipeCache.object(forKey: ingredients as NSString) as? [LocalRecipe]) ?? []
    }
}
