//
//  UILabel.swift
//  Reciplease
//
//  Created by pierrick viret on 28/09/2023.
//

import Foundation
import UIKit

extension UILabel {
    func setupDynamicTextWith( policeName: String, size: CGFloat, style: UIFont.TextStyle) {
        if let font = UIFont(name: policeName, size: size) {
            let fontMetrics = UIFontMetrics(forTextStyle: style)
            self.font = fontMetrics.scaledFont(for: font)
        }
        self.adjustsFontForContentSizeCategory = true
        self.numberOfLines = 0
    }
}
