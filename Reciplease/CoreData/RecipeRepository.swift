//
//  RecipeSaveRepository.swift
//  Reciplease
//
//  Created by pierrick viret on 16/10/2023.
//

import Foundation
import CoreData

final class RecipeRepository {

    // MARK: - Properties

    private let coreDataManager: CoreDataManager

    // MARK: - Init

    init(coreDataManager: CoreDataManager = CoreDataManager.sharedInstance) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Repository

    func saveRecipe(named recipe: LocalRecipe) {
        let viewContext = coreDataManager.viewContext
        viewContext.insert(recipe)

        coreDataManager.save()
    }

    func fetchSaveRecipes() -> [LocalRecipe] {
        let request: NSFetchRequest<LocalRecipe> = LocalRecipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \LocalRecipe.label, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return (try? coreDataManager.viewContext.fetch(request)) ?? []
    }

    func deleteRecipe( _ recipe: LocalRecipe) {
        coreDataManager.viewContext.delete(recipe)
        coreDataManager.save()
        print("del core data")
    }

    func transformInLocalAPI(_ recipe: Recipe) -> LocalRecipe {
        let localRecipe = LocalRecipe(context: coreDataManager.viewContext)

        localRecipe.label = recipe.label

        let text = recipe.ingredients.reduce("") { partialResult, ingredient in
            if partialResult == "" {
                partialResult + ingredient.food
            } else {
                partialResult + ", " + ingredient.food
            }
        }
        localRecipe.ingredients = text

        localRecipe.ingredientsLines = "- " + recipe.ingredientLines.joined(separator: "\n- ")

        localRecipe.imageUrl = recipe.images.regular.url
        localRecipe.totalTime = Int32(recipe.totalTime)
        localRecipe.yield = Int32(recipe.yield)
        localRecipe.sourceUrl = recipe.url

        return localRecipe
    }
}
