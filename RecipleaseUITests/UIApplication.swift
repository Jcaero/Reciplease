//
//  UIApplication.swift
//  RecipleaseUITests
//
//  Created by pierrick viret on 28/10/2023.
//

import Foundation
import XCTest
@testable import Reciplease

class UIApplication: XCUIApplication {
    var addButton: XCUIElement {self.buttons["Add"]}
    var searchButton: XCUIElement {self.buttons["searchButton"]}
    var clearButton: XCUIElement {self.buttons["Clear"]}
    var input: XCUIElement {self.searchFields["inputTextFields"]}
    var tabBarSearch: XCUIElement {tabBars.buttons.element(boundBy: 0)}
    var tabBarFavorite: XCUIElement {tabBars.buttons.element(boundBy: 1)}
}
