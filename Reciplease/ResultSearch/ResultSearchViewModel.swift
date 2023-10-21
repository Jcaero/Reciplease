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
    private let recipesSaveRepository = RecipeSaveManager()
    var recipes: [LocalRecipe] = []

    @Published var isNetworkSuccessful: Bool!
    @Published var isAlerte: ErrorMessage!

    func fetchInitRecipes(with ingredients: [String]) {
        self.isNetworkSuccessful = false

        repository.fetchRecip(ingredients)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                self.isAlerte = ErrorMessage(title: "Erreur", message: "Erreur de reseau")
            }
        } receiveValue: { [weak self] data in
            guard let self = self else { return }

            data.hits.forEach { hit in
                self.recipes.append(LocalRecipe(recipe: hit.recipe))
            }
            checkRecipes()
        }.store(in: &cancellables)
    }

    func fetchSaveRecipes() {
        recipes = recipesSaveRepository.fetchRecipes()
        checkRecipes()
    }

    private func checkRecipes() {
        if self.recipes.isEmpty == true {
            self.isAlerte = ErrorMessage(title: "Information", message: "Pas de recette disponible")
        } else {
            self.isNetworkSuccessful = true
        }
    }
}
