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

    func saveRecipe(named recipe: SaveRecipe) {
        let viewContext = coreDataManager.viewContext
        viewContext.insert(recipe)
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

    func deleteRecipe( _ recipe: SaveRecipe) {
        coreDataManager.viewContext.delete(recipe)
        coreDataManager.save()
        print("del core data")
    }

//    func transformInLocalAPI(_ recipe: Recipe) -> SaveRecipe {
//        let localRecipe = SaveRecipe(context: coreDataManager.viewContext)
//        localRecipe.label = recipe.label
//        localRecipe.ingredients = recipe.ingredients.map { $0.food }.joined(separator: ", ")
//        localRecipe.ingredientsLines = "- " + recipe.ingredientLines.joined(separator: "\n- ")
//        localRecipe.imageUrl = recipe.images.regular.url
//        localRecipe.totalTime = Int32(recipe.totalTime)
//        localRecipe.yield = Int32(recipe.yield)
//        localRecipe.sourceUrl = recipe.url
//        return localRecipe
//    }
}
