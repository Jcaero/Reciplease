//
//  UILabel+.swift
//  Reciplease
//
//  Created by pierrick viret on 27/09/2023.
//

import Foundation
import UIKit

extension UIView {
    func setAccessibility( with traits: UIAccessibilityTraits, label: String, hint: String) {
        self.isAccessibilityElement = true
        self.accessibilityTraits = traits
        self.accessibilityLabel = label
        self.accessibilityHint = hint
    }
}
