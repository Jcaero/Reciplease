//
//  RecipeSaveRepository.swift
//  Reciplease
//
//  Created by pierrick viret on 16/10/2023.
//

import Foundation
import CoreData

final class RecipeSaveManager {

    // MARK: - Properties

    private let coreDataManager: CoreDataManager

    // MARK: - Init

    init(coreDataManager: CoreDataManager = CoreDataManager.sharedInstance) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Repository

    func saveRecipe(named recipe: LocalRecipe) {
        let viewContext = coreDataManager.viewContext
        viewContext.insert(transformInSaveRecipe(LocalRecipe: recipe))
        coreDataManager.save()
    }

    func fetchRecipes() -> [LocalRecipe] {
        let saveRecipes = fetchSaveRecipes()
        return saveRecipes.map { saveRecipe in
            return LocalRecipe(saveRecipe: saveRecipe)
        }
    }

    private func fetchSaveRecipes() -> [SaveRecipe] {
        let request: NSFetchRequest<SaveRecipe> = SaveRecipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \SaveRecipe.label, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return (try? coreDataManager.viewContext.fetch(request)) ?? []
    }

    func deleteRecipe( _ recipe: LocalRecipe) {
        let context = coreDataManager.viewContext
        // Cast the result returned from the fetchRequest as Person class
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SaveRecipe")

        // fetch records which match this condition
        fetchRequest.predicate = NSPredicate(format: "label == %@", recipe.label)

        do {
            let recipesToDelete = try context.fetch(fetchRequest)
            for recipeToDelete in recipesToDelete {
                context.delete(recipeToDelete)
            }
            coreDataManager.save()
            print("Recipe deleted from Core Data")
        } catch let error as NSError {
            print("Could not fetch or delete. \(error), \(error.userInfo)")
        }
    }

    func transformInSaveRecipe(LocalRecipe recipe: LocalRecipe) -> SaveRecipe {
        let localRecipe = SaveRecipe(context: coreDataManager.viewContext)
        localRecipe.label = recipe.label
        localRecipe.listeOfIngredients = recipe.listeOfIngredients
        localRecipe.listeOfIngredientsWithDetail = recipe.listeOfIngredientsWithDetail
        localRecipe.imageUrl = recipe.imageUrl
        localRecipe.totalTime = Int16(recipe.totalTime)
        localRecipe.yield = Int16(recipe.yield)
        localRecipe.sourceUrl = recipe.sourceUrl
        localRecipe.isSave = true
        return localRecipe
    }
}
