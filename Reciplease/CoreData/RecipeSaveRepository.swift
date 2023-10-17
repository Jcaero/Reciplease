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

    func saveRecipe(named recipe: Recipe) {
        // create entity instance with context
        let saveRecipe = RecipeSave(context: coreDataManager.viewContext)
        // use
        saveRecipe.imageUrl = recipe.images.regular.url
        saveRecipe.label = recipe.label
        saveRecipe.yield = Int32(recipe.yield)
        saveRecipe.totalTime = Int32(recipe.totalTime)

        coreDataManager.save()
    }

    func fetchSaveRecipes() -> [RecipeSave] {
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \RecipeSave.label , ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return (try? coreDataManager.viewContext.fetch(request)) ?? []
    }

    func deleteRecipe( _ recipe: RecipeSave) {
        coreDataManager.viewContext.delete(recipe)
        coreDataManager.save()
        print("del core data")
    }
}
