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
                    URLQueryItem(name: "app_id", value: APIKey.recipe.id),
                ]
                componments.queryItems = queryItems
                return componments.url!
            }
        }
    }
    
    struct RecipResponse: Decodable {
        let count: Int
        let hits: [Hit]
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
    let links: HitLinks

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

struct HitLinks: Codable {
    let selfHit: SelfHitLink

    enum CodingKeys: String, CodingKey {
        case selfHit = "self"
    }
}

struct SelfHitLink: Codable {
    let href: String
}

// MARK: - Recipe
struct Recipe: Codable {
    let uri: String
    let label: String
    let image: String
    let images: Images
    let source: String
    let url: String
    let shareAs: String
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories: Double
    let totalWeight: Double
    let totalTime: Int
    let cuisineType: [String]
}

// MARK: - Images
struct Images: Codable {
    let thumbnail, small, regular: Large
    let large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let quantity: Double
    let measure: String?
    let food: String
    let weight: Double
    let foodCategory, foodID: String
    let image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodID = "foodId"
        case image
    }
}
