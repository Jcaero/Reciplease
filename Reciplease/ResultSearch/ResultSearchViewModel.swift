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
    private let recipRepository = RecipeSaveManager()
    var recipes: [LocalRecipe] = []

    @Published var isNetworkSuccessful: Bool!
    @Published var isAlerte: String!

    func fetchInitRecipes(with ingredients: [String]) {
        self.isNetworkSuccessful = false

        repository.fetchRecip(ingredients)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                self.isAlerte = "Erreur de reseau"
            }
        } receiveValue: { [weak self] data in
            guard let self = self else { return }

            data.hits.forEach { hit in
                self.recipes.append(LocalRecipe(recipe: hit.recipe))
            }
            if self.recipes.isEmpty == true {
                self.isAlerte = "Pas de recette disponible"
            } else {
                self.isNetworkSuccessful = true
            }
        }.store(in: &cancellables)
    }
}
