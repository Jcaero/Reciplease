//
//  Repository.swift
//  Reciplease
//
//  Created by pierrick viret on 01/10/2023.
//

import Foundation
import Combine
import Alamofire

protocol NetworkRepositoryProtocol {
    func fetchRecip(_ liste: [String]) -> AnyPublisher<API.RecipResponse, Error>
    func fetchMoreRecipe(_ nextPage: String) -> AnyPublisher<API.RecipResponse, Error>
}

class NetworkRepository: NetworkRepositoryProtocol, ObservableObject {

    private let sessionManager: Session

    init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        self.sessionManager = Session(configuration: sessionConfiguration)
    }

    func fetchRecip(_ liste: [String]) -> AnyPublisher<API.RecipResponse, Error> {
        let ingredients = liste.joined(separator: " ")
        let url = API.EndPoint.recip(ingredients).url

        return AF.request(url, method: .get, parameters: nil)
            .publishDecodable(type: API.RecipResponse.self)
            .value()
            .mapError {$0 as Error}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchMoreRecipe(_ nextPage: String) -> AnyPublisher<API.RecipResponse, Error> {
        guard let url = URL(string: nextPage) else {
               return Fail(error: URLError(.badURL))
                   .eraseToAnyPublisher()
           }

        return AF.request(url, method: .get, parameters: nil)
            .publishDecodable(type: API.RecipResponse.self)
            .value()
            .mapError {$0 as Error}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
