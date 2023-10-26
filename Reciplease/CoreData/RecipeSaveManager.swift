//
//  RecipeSaveRepository.swift
//  Reciplease
//
//  Created by pierrick viret on 16/10/2023.
//

import Foundation
import CoreData
import UIKit

final class RecipeSaveManager {

    // MARK: - Properties

    private let coreDataManager: CoreDataManager
    private let context: NSManagedObjectContext!

    // MARK: - Init

    init(coreDataManager: CoreDataManager = CoreDataManager.sharedInstance) {
        self.coreDataManager = coreDataManager
        context = coreDataManager.viewContext
    }

    // MARK: - Repository

    func saveRecipe(named recipe: LocalRecipe, image: UIImage?) {
        guard !isSaveRecipeContains(recipe) else { return }
        addInContext(LocalRecipe: recipe, recipeImage: image)
        coreDataManager.save()
    }

    func fetchRecipes() -> [LocalRecipe] {
        return fetchSaveRecipes().map(LocalRecipe.init)
    }

    private func fetchSaveRecipes() -> [SaveRecipe] {
        let request: NSFetchRequest<SaveRecipe> = SaveRecipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \SaveRecipe.label, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            return try coreDataManager.viewContext.fetch(request)
        } catch {
            print("Error fetching SaveRecipes: \(error)")
            return []
        }
    }

    func deleteRecipe( _ recipe: LocalRecipe) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SaveRecipe")
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

    func addInContext(LocalRecipe recipe: LocalRecipe, recipeImage: UIImage?) {
        let localRecipe = SaveRecipe(context: coreDataManager.viewContext)
        localRecipe.label = recipe.label
        localRecipe.listeOfIngredients = recipe.listeOfIngredients as NSArray
        localRecipe.listeOfIngredientsWithDetail = recipe.listeOfIngredientsWithDetail
        localRecipe.imageUrl = recipe.imageUrl
        localRecipe.totalTime = Int16(recipe.totalTime)
        localRecipe.yield = Int16(recipe.yield)
        localRecipe.sourceUrl = recipe.sourceUrl
        localRecipe.isSave = true
        if let image = recipeImage {
            localRecipe.imageData = image.jpegData(compressionQuality: 1)
        }
    }

    func isSaveRecipeContains(_ recipe: LocalRecipe) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SaveRecipe")
         fetchRequest.predicate = NSPredicate(format: "label == %@", recipe.label)

         do {
             let recipeFetched = try context.fetch(fetchRequest)
             return !recipeFetched.isEmpty
         } catch let error as NSError {
             print("Could not fetch or delete. \(error), \(error.userInfo)")
             return false
         }
    }
}
