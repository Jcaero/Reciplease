//
//  SearchController.swift
//  Reciplease
//
//  Created by pierrick viret on 25/09/2023.
//

import UIKit

class SearchController: UIViewController {
    //

    let searchArea: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let searchStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()

    let questionTitle: UILabel = {
       let label = UILabel()
        label.text = "What's in your fridge ?"
        label.setupDynamicTextWith(policeName: "Symbol", size: 35, style: .largeTitle)
        label.textColor = .anthraciteGray
        label.textAlignment = .center
        label.setAccessibility(with: .header, label: "Question Title", hint: "What's in your fridge ?")
        return label
    }()

    let addIngredients: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.setupDynamicTextWith(style: .body)
        button.layer.cornerRadius = 5
        button.setAccessibility(with: .button, label: "Add ingredient", hint: "Pressed button to add ingredient")
        return button
    }()

    let inputIngredients: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Lemon, Cheese..."
        textField.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .title3)
        textField.textAlignment = .justified
        textField.textColor = .darkGray
        textField.setAccessibility(with: .searchField, label: "input Ingredients", hint: "Area to input your ingredient")
        return textField
    }()

    let underligne: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let inputStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.axis = .horizontal
        view.distribution = .fillProportionally
        return view
    }()

    let searchRecipes: UIButton = {
        let button = UIButton()
        button.setTitle("Search for recipes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .footnote)
        button.layer.cornerRadius = 5
        button.setAccessibility(with: .button, label: "search for recipes", hint: "Pressed button to search recipes with ingredients")
        return button
    }()

    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init navigation controller
        view.backgroundColor = .anthraciteGray
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Chalkduster", size: 25)!,
                                                                   .foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.title = "Reciplease"

        setupView()
    }

    // MARK: - Layout
    private func setupView() {
        [searchStackView, questionTitle, addIngredients, inputIngredients, underligne, inputStackView, searchRecipes, searchArea].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(searchArea)
        NSLayoutConstraint.activate([
            searchArea.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchArea.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchArea.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])

        searchArea.addSubview(searchStackView)
        NSLayoutConstraint.activate([
            searchStackView.leftAnchor.constraint(equalTo: searchArea.leftAnchor, constant: 5),
            searchStackView.rightAnchor.constraint(equalTo: searchArea.rightAnchor, constant: -5),
            searchStackView.topAnchor.constraint(equalTo: searchArea.topAnchor, constant: 10),
            searchArea.bottomAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 15)
        ])

        searchStackView.addArrangedSubview(questionTitle)
        searchStackView.addArrangedSubview(inputStackView)

        inputStackView.addArrangedSubview(inputIngredients)
        inputStackView.addArrangedSubview(addIngredients)

        searchStackView.addSubview(underligne)
        NSLayoutConstraint.activate([
            underligne.heightAnchor.constraint(equalToConstant: 1),
            underligne.leftAnchor.constraint(equalTo: inputIngredients.leftAnchor),
            underligne.rightAnchor.constraint(equalTo: inputIngredients.rightAnchor),
            underligne.topAnchor.constraint(equalTo: inputIngredients.bottomAnchor, constant: 5)
        ])

        view.addSubview(searchRecipes)
        NSLayoutConstraint.activate([
            searchRecipes.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchRecipes.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            searchRecipes.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            searchRecipes.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}

// MARK: - Accessibility
extension SearchController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        updateDisplayAccessibility()
    }

    func updateDisplayAccessibility() {
        let currentCategory = traitCollection.preferredContentSizeCategory
        if currentCategory.isAccessibilityCategory {
            inputStackView.axis = .vertical
            inputIngredients.placeholder = "ingredient"
            searchRecipes.setTitle("Search", for: .normal)
            questionTitle.isHidden = true
        } else {
            inputStackView.axis = .horizontal
            inputIngredients.placeholder = "Lemon, Cheese..."
            searchRecipes.setTitle("Search for recipes", for: .normal)
            questionTitle.isHidden = false
        }
    }
}
