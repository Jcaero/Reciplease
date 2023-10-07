//
//  ResultSearchViewModel.swift
//  Reciplease
//
//  Created by pierrick viret on 03/10/2023.
//

import Foundation
import Combine

class ResultSearchViewModel: ObservableObject {

    var cancellables = Set<AnyCancellable>()

    var recipes: [Hit] = []
    @Published var isLoading = true

    func fetchInitRecipes(with ingredients: [String]) {
        self.isLoading = true
        Repository().fetchRecip(ingredients)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                break
            }
        } receiveValue: { data in
            self.recipes = data.hits
            self.isLoading = false
        }.store(in: &cancellables)
    }
}
