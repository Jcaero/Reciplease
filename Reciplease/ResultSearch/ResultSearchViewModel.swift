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

    func fetchInitRecipes(with ingredients: [String]) {
        Repository().fetchRecip(ingredients)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                break
            }
        } receiveValue: { data in
            print("\(data.hits.count)")
        }.store(in: &cancellables)
    }
}
