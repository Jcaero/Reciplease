//
//  SearchController.swift
//  Reciplease
//
//  Created by pierrick viret on 25/09/2023.
//

import UIKit

class SearchController: UIViewController {

    // SearchArea
    let searchArea: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let questionTitle: UILabel = {
       let label = UILabel()
        label.text = "What's in your fridge ?"
        label.font = UIFont(name: "Lincoln Road", size: 50)
        label.font = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
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
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.numberOfLines = 0
        button.layer.cornerRadius = 5
        button.setAccessibility(with: .button, label: "Add ingredient", hint: "Pressed button to add ingredient")
        return button
    }()

    let inputIngredients: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Lemon, Cheese, Sausages..."
        textField.font = UIFont(name: "Lincoln Road", size: 30)
        textField.font = UIFont.preferredFont(forTextStyle: .title3)
        textField.adjustsFontForContentSizeCategory = true
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
        view.spacing = 10
        return view
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
        [searchArea, questionTitle, addIngredients, inputIngredients, underligne, inputStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(searchArea)
        NSLayoutConstraint.activate([
            searchArea.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchArea.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])

        searchArea.addSubview(questionTitle)
        NSLayoutConstraint.activate([
            questionTitle.leftAnchor.constraint(equalTo: searchArea.leftAnchor),
            questionTitle.rightAnchor.constraint(equalTo: searchArea.rightAnchor),
            questionTitle.topAnchor.constraint(equalTo: searchArea.topAnchor)
        ])

        searchArea.addSubview(inputStackView)
        NSLayoutConstraint.activate([
            inputStackView.leftAnchor.constraint(equalTo: searchArea.leftAnchor, constant: 5),
            inputStackView.rightAnchor.constraint(equalTo: searchArea.rightAnchor, constant: -5),
            inputStackView.topAnchor.constraint(equalTo: questionTitle.bottomAnchor)
        ])

        inputStackView.addArrangedSubview(inputIngredients)
        inputStackView.addArrangedSubview(addIngredients)

        searchArea.addSubview(underligne)
        NSLayoutConstraint.activate([
            underligne.heightAnchor.constraint(equalToConstant: 1),
            underligne.leftAnchor.constraint(equalTo: inputIngredients.leftAnchor),
            underligne.rightAnchor.constraint(equalTo: inputIngredients.rightAnchor),
            underligne.topAnchor.constraint(equalTo: inputIngredients.bottomAnchor, constant: 5),
            searchArea.bottomAnchor.constraint(equalTo: underligne.bottomAnchor, constant: 10)
        ])
    }
}

// MARK: - Accessibility
extension SearchController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let currentCategory =
            traitCollection.preferredContentSizeCategory
        let previousCategory =
            previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }

        if currentCategory.isAccessibilityCategory {
            inputStackView.axis = .vertical
            inputIngredients.placeholder = "ingredient"
        } else {
            inputStackView.axis = .horizontal
        }
    }
}
