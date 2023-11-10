//
//  SaveRecipe+CoreDataProperties.swift
//  Reciplease
//
//  Created by pierrick viret on 27/10/2023.
//
//

import Foundation
import CoreData

extension SaveRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaveRecipe> {
        return NSFetchRequest<SaveRecipe>(entityName: "SaveRecipe")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isSave: Bool
    @NSManaged public var label: String?
    @NSManaged public var listeOfIngredientsWithDetail: [String]?
    @NSManaged public var sourceUrl: String?
    @NSManaged public var totalTime: Int16
    @NSManaged public var yield: Int16
    @NSManaged public var ingredients: Set<SaveIngredient>?

    var ingredientsListe: [Ingredient] {
        let setOfIngredients = ingredients
        return setOfIngredients!.compactMap {saveIngredient in
            return Ingredient(food: saveIngredient.food)
        }
    }
}

// MARK: Generated accessors for ingredient
extension SaveRecipe {

    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: SaveIngredient)

    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: SaveIngredient)

    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSSet)

    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)
}

extension SaveRecipe: Identifiable {

}
