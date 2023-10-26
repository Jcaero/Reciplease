//
//  searchViewModel.swift
//  Reciplease
//
//  Created by pierrick viret on 30/09/2023.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()

    var ingredients: [String] = [] {
        didSet {
            if self.ingredients.isEmpty {
                ingredientList = ""
            } else {
                ingredientList = "- " + ingredients.joined(separator: "\n- ")
            }
        }
    }
    @Published var ingredientList: String = ""

    func addIngredient(_ name: String?) {
        guard let ingredient = name, !ingredient.isEmpty, !ingredientList.contains(ingredient) else { return}

        ingredients.append(ingredient)
    }

    func clearIngredientList() {
        ingredients.removeAll()
    }
}
