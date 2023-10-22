//
//  ResultSearchViewModel.swift
//  Reciplease
//
//  Created by pierrick viret on 03/10/2023.
//

import Foundation
import UIKit
import Combine

class ResultSearchViewModel: ObservableObject {

    var cancellables = Set<AnyCancellable>()

    private let repository = Repository()
    private let recipesSaveManager = RecipeSaveManager()
    var recipes: [LocalRecipe] = []
    private var ingredientsKey: String!

    @Published var isNetworkSuccessful: Bool!
    @Published var isAlerte: ErrorMessage!

    func fetchInitRecipes(with ingredients: [String]) {
        self.ingredientsKey = ingredients.joined(separator: ",")
        if haveRecipesInCache() {
            checkIfRecipesCanBeShow()
        } else {
            fetchRecipes(with: ingredients)
        }
    }

    private func fetchRecipes(with ingredients: [String]) {
        self.isNetworkSuccessful = false

        repository.fetchRecip(ingredients)
            .sink { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                case .finished:
                    break
                case .failure:
                    self.isAlerte = ErrorMessage(title: "Erreur", message: "Erreur de reseau")
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }

                self.recipes = data.hits.map { LocalRecipe(recipe: $0.recipe) }
                self.checkIfRecipesCanBeShow()
            }.store(in: &cancellables)
    }

    func fetchSaveRecipes() {
        recipes = recipesSaveManager.fetchRecipes()
        checkIfRecipesCanBeShow()
    }

    private func checkIfRecipesCanBeShow() {
        if self.recipes.isEmpty == true {
            self.isAlerte = ErrorMessage(title: "Information", message: "Pas de recette disponible")
        } else {
            RecipeResultCache.shared.save(recipes: recipes, forKey: ingredientsKey)
            self.isNetworkSuccessful = true
        }
    }

    private func haveRecipesInCache() -> Bool {
        recipes = RecipeResultCache.shared.getRecipes(for: ingredientsKey)
        return !recipes.isEmpty
    }
}
