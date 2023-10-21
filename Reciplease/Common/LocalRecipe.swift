//
//  LocalRecipe.swift
//  Reciplease
//
//  Created by pierrick viret on 21/10/2023.
//

import Foundation
import UIKit

class LocalRecipe {
    var label: String
    var imageUrl: String
    var image: UIImage?
    var sourceUrl: String
    var listeOfIngredients: String
    var listeOfIngredientsWithDetail: String
    var totalTime: Int
    var yield: Int

    init( recipe: Recipe) {
        self.label = recipe.label
        self.imageUrl = recipe.images.regular.url
        self.sourceUrl = recipe.url
        self.listeOfIngredients = recipe.ingredients.map { $0.food }.joined(separator: ", ")
        self.listeOfIngredientsWithDetail = "- " + recipe.ingredientLines.joined(separator: "\n- ")
        self.totalTime = recipe.totalTime
        self.yield = recipe.yield
    }

    init( saveRecipe: SaveRecipe) {
        self.label = saveRecipe.label ?? ""
        self.imageUrl = saveRecipe.imageUrl ?? ""
        self.sourceUrl = saveRecipe.sourceUrl ?? ""
        self.listeOfIngredients = saveRecipe.listeOfIngredients ?? ""
        self.listeOfIngredientsWithDetail = saveRecipe.listeOfIngredientsWithDetail ?? ""
        self.totalTime = Int(saveRecipe.totalTime)
        self.yield = Int(saveRecipe.yield)
    }
}

