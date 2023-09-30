//
//  UITextView+.swift
//  Reciplease
//
//  Created by pierrick viret on 29/09/2023.
//

import Foundation
import UIKit

extension UITextView {
    func setupDynamicTextWith( policeName: String, size: CGFloat, style: UIFont.TextStyle) {
        if let font = UIFont(name: policeName, size: size) {
            let fontMetrics = UIFontMetrics(forTextStyle: style)
            self.font = fontMetrics.scaledFont(for: font)
        }
        self.adjustsFontForContentSizeCategory = true
    }
}
