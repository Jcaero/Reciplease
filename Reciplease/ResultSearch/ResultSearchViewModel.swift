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

    private let repository: Repository
    var recipes: [Hit] = []
    @Published var isNetworkSuccessful: Bool!

    init(repository: Repository = Repository()) {
        self.repository = repository
    }

    func fetchInitRecipes(with ingredients: [String]) {
        self.isNetworkSuccessful = false
        repository.fetchRecip(ingredients)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                print("erreur reseau")
            }
        } receiveValue: { data in
            self.recipes = data.hits
            self.isNetworkSuccessful = true
        }.store(in: &cancellables)
    }
}
