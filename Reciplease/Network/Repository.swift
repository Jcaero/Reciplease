//
//  Repository.swift
//  Reciplease
//
//  Created by pierrick viret on 01/10/2023.
//

import Foundation
import Combine
import Alamofire

class Repository {
    func fetchRecip(_ liste: [String]) -> AnyPublisher<API.RecipResponse, Error> {
        let ingredients = transformInString(liste)
        let url = API.EndPoint.recip(ingredients).url
        
        AF.request(url).response { response in
                    guard let data = response.data else {return}
                    
                    do {
                        let movies = try JSONDecoder().decode([MovieData].self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            debugPrint(movies)
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }.resume()

        let data = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map{($0.data)}
            .decode(type: API.RecipResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        return data
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
