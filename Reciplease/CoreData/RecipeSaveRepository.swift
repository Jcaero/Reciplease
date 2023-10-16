//
//  RecipeSaveRepository.swift
//  Reciplease
//
//  Created by pierrick viret on 16/10/2023.
//


import Foundation
import CoreData

final class RecipeSaveRepository {

    // MARK: - Properties

    private let coreDataManager: CoreDataManager

    // MARK: - Init

    init(coreDataManager: CoreDataManager = CoreDataManager.sharedInstance) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Repository

    func saveRecipe(named recipe: Recipe, callback: @escaping () -> Void) {
        // create entity instance with context
        let saveRecipe = RecipeSave(context: coreDataManager.viewContext)
        // use
        saveRecipe.imageUrl = recipe.images.regular.url
        saveRecipe.label = recipe.label
        saveRecipe.yield = Int32(recipe.yield)
        saveRecipe.totalTime = Int32(recipe.totalTime)
        
        do {
            try coreDataManager.viewContext.save()
            callback()
        } catch {
            print("We were unable to save \(recipe.label)")
        }
    }
}
