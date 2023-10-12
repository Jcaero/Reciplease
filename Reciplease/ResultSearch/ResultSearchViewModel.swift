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
    var recipes: [Hit] = []

    @Published var isNetworkSuccessful: Bool!
    @Published var isAlerte: Bool!

    func fetchInitRecipes(with ingredients: [String]) {
        self.isNetworkSuccessful = false
        self.isAlerte = false
        
        repository.fetchRecip(ingredients)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                break
            }
        } receiveValue: { data in
            self.recipes = data.hits
            if self.recipes.isEmpty == true {
                self.isAlerte = true
            } else {
                self.isNetworkSuccessful = true
            }
        }.store(in: &cancellables)
    }
}
