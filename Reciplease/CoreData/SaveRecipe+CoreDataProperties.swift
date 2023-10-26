//
//  SaveRecipe+CoreDataProperties.swift
//  Reciplease
//
//  Created by pierrick viret on 26/10/2023.
//
//

import Foundation
import CoreData


@objc(SaveRecipe)
class SaveRecipe: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaveRecipe> {
        return NSFetchRequest<SaveRecipe>(entityName: "SaveRecipe")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isSave: Bool
    @NSManaged public var label: String?
    @NSManaged public var listeOfIngredients: NSArray?
    @NSManaged public var listeOfIngredientsWithDetail: [String]?
    @NSManaged public var sourceUrl: String?
    @NSManaged public var totalTime: Int16
    @NSManaged public var yield: Int16

}

extension SaveRecipe : Identifiable {

}
