//
//  TestCase.swift
//  RecipleaseTests
//
//  Created by pierrick viret on 01/10/2023.
//

import Foundation
import XCTest
@testable import Reciplease

class TestCase: XCTestCase {
    let mockRecipe = Recipe(uri: "http://www.edamam.com/Lemon",
                        label: "Blueberry-Lemon",
                        images: Images(regular: Large(url: "https://edamam-product-images/Lemon")),
                        source: "Food Network",
                        url: "https://www.foodnetwork.com/recipes/Blueberry-Lemon",
                        yield: 12,
                        ingredientLines: [
                            "2 pints blueberries (about 12 ounces)",
                            "2 tablespoons lemon juice"
                        ],
                        ingredients: [Ingredient(food: "Lemon"), Ingredient(food: "blueberries")],
                        totalTime: 2)

    func getData(fromJson file: String) -> Data? {
        // get bundle of class
        let bundle = Bundle(for: APITest.self)
        // get url of file and data
        if let url = bundle.url(forResource: file, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                print("Error reading data: \(error)")
                return nil
            }
        } else {
            print("File not found")
            return nil
        }
    }
}
