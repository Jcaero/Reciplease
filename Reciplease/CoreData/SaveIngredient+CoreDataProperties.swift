//
//  SaveIngredient+CoreDataProperties.swift
//  Reciplease
//
//  Created by pierrick viret on 27/10/2023.
//
//

import Foundation
import CoreData

extension SaveIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaveIngredient> {
        return NSFetchRequest<SaveIngredient>(entityName: "SaveIngredient")
    }

    @NSManaged public var food: String
    @NSManaged public var recipe: NSSet?

}

// MARK: Generated accessors for recipe
extension SaveIngredient {

    @objc(addRecipeObject:)
    @NSManaged public func addToRecipe(_ value: SaveRecipe)

    @objc(removeRecipeObject:)
    @NSManaged public func removeFromRecipe(_ value: SaveRecipe)

    @objc(addRecipe:)
    @NSManaged public func addToRecipe(_ values: NSSet)

    @objc(removeRecipe:)
    @NSManaged public func removeFromRecipe(_ values: NSSet)

}

extension SaveIngredient: Identifiable {

}
