//
//  ResultSearchViewController.swift
//  Reciplease
//
//  Created by pierrick viret on 30/09/2023.
//

import UIKit

class ResultSearchViewController: UIViewController {

    private var ingredients: [String] = []

    init(ingredients: [String] = []) {
        super.init(nibName: nil, bundle: nil)
        self.ingredients = ingredients
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .anthraciteGray
        print("\(ingredients[0])")
    }
}
