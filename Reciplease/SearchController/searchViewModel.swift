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

    private var ingredients: [String] = []
    @Published var ingredientList: String = ""

    func addIngredient(_ name: String?) {
        guard let ingredient = name,
        ingredient != ""
        else { return}

        ingredients.append(ingredient)

        switch ingredientList {
        case "": ingredientList = "- " + ingredient
        default: ingredientList = ingredientList + "\n- " + ingredient
        }
    }
}
