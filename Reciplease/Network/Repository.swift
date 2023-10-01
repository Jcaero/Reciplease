//
//  Repository.swift
//  Reciplease
//
//  Created by pierrick viret on 01/10/2023.
//

import Foundation
import Combine
import Alamofire

class Repository: ObservableObject {

    private let sessionManager: Session

    init(sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        self.sessionManager = Session(configuration: sessionConfiguration)
    }

    func fetchRecip(_ liste: [String]) -> AnyPublisher<API.RecipResponse, Error> {
        let ingredients = transformInString(liste)
        let url = API.EndPoint.recip(ingredients).url

        return AF.request(url, method: .get, parameters: nil)
            .publishDecodable(type: API.RecipResponse.self)
            .value()
            .mapError {$0 as Error}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func transformInString(_ liste: [String]) -> String {
        var ingredients: String = ""
        liste.forEach { ingredient in
            switch ingredients {
            case "": ingredients = ingredient
            default: ingredients = ingredients + " " + ingredient
            }
        }
        return ingredients
    }
}
