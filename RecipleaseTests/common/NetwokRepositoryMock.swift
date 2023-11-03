//
//  NetwokRepositoryMock.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 28/10/2023.
//

import Foundation
import UIKit
import Combine

@testable import Reciplease

class NetwokRepositoryMock: NetworkRepositoryProtocol {
    func fetchMoreRecipe(_ nextPage: String) -> AnyPublisher<Reciplease.API.RecipResponse, Error> {
        let error = NSError(domain: "Reciplease", code: 666, userInfo: [NSLocalizedDescriptionKey: "Erreur simulée"])
        return Fail(error: error).eraseToAnyPublisher()
    }

    var mockResult: API.RecipResponse?

    init(mockResult: Recipe?) {
        guard let mockResult = mockResult else { return }
        let simulatedNext = Next(href: nil)
        let simulatedLinks = RecipResponseLinks(next: simulatedNext)
        let simulatedHit = Hit(recipe: mockResult)

        let simulatedResponse = API.RecipResponse(links: simulatedLinks, hits: [simulatedHit])
        self.mockResult = simulatedResponse
    }

    func fetchRecip(_ liste: [String]) -> AnyPublisher<API.RecipResponse, Error> {
        if let result = mockResult {
            return Result.Publisher(.success(result)).eraseToAnyPublisher()
        } else {
            let error = NSError(domain: "Reciplease", code: 666, userInfo: [NSLocalizedDescriptionKey: "Erreur simulée"])
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
