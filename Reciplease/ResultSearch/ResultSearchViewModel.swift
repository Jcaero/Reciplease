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

    private let repository: NetworkRepositoryProtocol
    private let recipesSaveManager: RecipeSaveManagerProtocol
    private let recipeCacheManager: RecipeCacheManagerProtocol
    private var ingredientsKey: String = ""

    var recipes: [LocalRecipe] = []

    @Published var isNetworkSuccessful = false
    @Published var alerteMessage: ErrorMessage?

    init(repository: NetworkRepositoryProtocol = NetworkRepository(),
         recipesSaveManager: RecipeSaveManagerProtocol = RecipeSaveManager(),
         recipeCacheManager: RecipeCacheManagerProtocol = RecipeCacheManager.shared) {
        self.repository = repository
        self.recipesSaveManager = recipesSaveManager
        self.recipeCacheManager = recipeCacheManager
    }

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
                    self.alerteMessage = ErrorMessage(title: "Erreur", message: "Erreur de reseau")
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
        if self.recipes.isEmpty {
            alerteMessage = ErrorMessage(title: "Information", message: "Pas de recette disponible")
        } else {
            recipeCacheManager.save(recipes: recipes, forKey: ingredientsKey)
            isNetworkSuccessful = true
        }
    }

    private func haveRecipesInCache() -> Bool {
        recipes = recipeCacheManager.getRecipes(for: ingredientsKey)
        return !recipes.isEmpty
    }
}
