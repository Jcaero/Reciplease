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
    private var ingredients: [String] = []
    private var ingredientsKey: String { return ingredients.joined(separator: ",") }

    var recipes: [LocalRecipe] = []
    var nextPage: String?

    @Published var isNetworkSuccessful = false
    @Published var alerteMessage: ErrorMessage?

    // MARK: - INIT
    init(repository: NetworkRepositoryProtocol = NetworkRepository(),
         recipesSaveManager: RecipeSaveManagerProtocol = RecipeSaveManager(),
         recipeCacheManager: RecipeCacheManagerProtocol = RecipeCacheManager.shared) {
        self.repository = repository
        self.recipesSaveManager = recipesSaveManager
        self.recipeCacheManager = recipeCacheManager
    }

    // MARK: - Fetch function
    func fetchInitRecipes(with ingredients: [String]) {
        self.ingredients = ingredients
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
                self.nextPage = data.links.next.href
                self.recipes = data.hits.map { LocalRecipe(recipe: $0.recipe) }
                self.checkIfRecipesCanBeShow()
            }.store(in: &cancellables)
    }

    func fetchSaveRecipes() {
        recipes = recipesSaveManager.fetchRecipes()
        checkIfRecipesCanBeShow()
    }

    func fetchMoreRecipes() {
        guard let url = nextPage else { return }
        self.isNetworkSuccessful = false

        repository.fetchMoreRecipe(url)
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
                self.nextPage = data.links.next.href
                self.recipes.append(contentsOf: data.hits.map { LocalRecipe(recipe: $0.recipe) })
                self.checkIfRecipesCanBeShow()
            }.store(in: &cancellables)
    }

    // MARK: - check function
    private func checkIfRecipesCanBeShow() {
        print("count is \(recipes.count)")
        if self.recipes.isEmpty {
            alerteMessage = ErrorMessage(title: "Information", message: "Pas de recette disponible")
        } else {
            recipeCacheManager.save(recipes: recipes, nextPage: nextPage, forKey: ingredientsKey)
            isNetworkSuccessful = true
        }
    }

    // MARK: - cache gestion
    private func haveRecipesInCache() -> Bool {
        let (cachedRecipes, cachedNextPage) = recipeCacheManager.getRecipes(for: ingredientsKey)

        recipes = cachedRecipes
        nextPage = cachedNextPage
        return !recipes.isEmpty
    }

    private func removeInCache() {
        recipeCacheManager.remove(for: ingredientsKey)
    }

    // MARK: - refresh
    func refreshData(completion: (() -> Void)) {
        removeInCache()
        fetchRecipes(with: ingredients)
        completion()
    }
}
