//
//  RecipAPIModel.swift
//  Reciplease
//
//  Created by pierrick viret on 01/10/2023.
//

import Foundation
enum API {
    // MARK: - ENDPOINT
    enum EndPoint {
        case recip(String)

        var url: URL {
            switch self {
            case .recip(let addQueryItems):
                var componments = URLComponents()
                componments.scheme = "https"
                componments.host = "api.edamam.com"
                componments.path = "/api/recipes/v2"
                let queryItems = [
                    URLQueryItem(name: "type", value: "public"),
                    URLQueryItem(name: "q", value: addQueryItems),
                    URLQueryItem(name: "app_key", value: APIKey.recipe.key),
                    URLQueryItem(name: "app_id", value: APIKey.recipe.id)
                ]
                componments.queryItems = queryItems
                return componments.url!
            }
        }
    }

    struct RecipResponse: Codable {
        let links: RecipResponseLinks
        let hits: [Hit]

        enum CodingKeys: String, CodingKey {
            case links = "_links"
            case hits
        }
    }
}

struct RecipResponseLinks: Codable {
    let next: Next
}

// MARK: - Next
struct Next: Codable {
    let href: String?
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let images: Images
    let source: String
    let url: String
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let totalTime: Int
}

// MARK: - Images
struct Images: Codable {
    let regular: Large

    enum CodingKeys: String, CodingKey {
        case regular = "REGULAR"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String
}

// MARK: - Ingredient
struct Ingredient: Codable, Hashable {
    var food: String
}
