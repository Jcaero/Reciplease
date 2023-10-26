//
//  ArrayIngredienttransformer.swift
//  Reciplease
//
//  Created by pierrick viret on 26/10/2023.
//

import Foundation
import UIKit

class ArrayIngredientTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let anylisteOfIngredients = value as? [Ingredient] else { return nil }

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: anylisteOfIngredients, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil}

        do {
            let listeOfIngredients = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [Ingredient]
            return listeOfIngredients
        } catch {
            return nil
        }
    }
}
