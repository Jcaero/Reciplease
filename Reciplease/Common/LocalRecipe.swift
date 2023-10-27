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
    var listeOfIngredients: [Ingredient]
    var listeOfIngredientsWithDetail: [String]
    var totalTime: Int
    var yield: Int
    var isSave: Bool = false

    init( recipe: Recipe) {
        self.label = recipe.label
        self.imageUrl = recipe.images.regular.url
        self.sourceUrl = recipe.url
        self.listeOfIngredients = recipe.ingredients
        self.listeOfIngredientsWithDetail = recipe.ingredientLines
        self.totalTime = recipe.totalTime
        self.yield = recipe.yield
    }

    init( saveRecipe: SaveRecipe) {
        self.label = saveRecipe.label ?? ""
        self.imageUrl = saveRecipe.imageUrl ?? ""
        self.sourceUrl = saveRecipe.sourceUrl ?? ""
        self.listeOfIngredients = saveRecipe.ingredientsListe
        self.listeOfIngredientsWithDetail = saveRecipe.listeOfIngredientsWithDetail ?? []
        self.totalTime = Int(saveRecipe.totalTime)
        self.yield = Int(saveRecipe.yield)
        self.isSave = saveRecipe.isSave

        if let imageData = saveRecipe.imageData, let image = UIImage(data: imageData) {
                self.image = image
        }
    }
}
