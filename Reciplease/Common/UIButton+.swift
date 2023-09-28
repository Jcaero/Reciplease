//
//  UIButton+.swift
//  Reciplease
//
//  Created by pierrick viret on 28/09/2023.
//

import Foundation
import UIKit

extension UIButton {
    func setupDynamicTextWith( style: UIFont.TextStyle) {
        self.titleLabel?.font = UIFont.preferredFont(forTextStyle: style)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        self.titleLabel?.numberOfLines = 0
    }

    func setupDynamicTextWith(policeName: String, size: CGFloat, style: UIFont.TextStyle) {
        if let font = UIFont(name: policeName, size: size) {
            let fontMetrics = UIFontMetrics(forTextStyle: style)
            self.titleLabel?.font = fontMetrics.scaledFont(for: font)
        } else {
            self.titleLabel?.font = UIFont.preferredFont(forTextStyle: style)
        }
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        self.titleLabel?.numberOfLines = 0
    }
}
