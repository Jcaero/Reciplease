//
//  SearchController.swift
//  Reciplease
//
//  Created by pierrick viret on 25/09/2023.
//

import UIKit
import Combine

class SearchController: ViewController {
    // MARK: - liste of UI
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
        label.setAccessibility(with: .header, label: "What's in your fridge ?", hint: "Question")
        return label
    }()

    let inputStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()

    lazy var addIngredients: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGreen
        button.setupDynamicTextWith(style: .body)
        button.layer.cornerRadius = 5
        button.setAccessibility(with: .button, label: "Add ingredient", hint: "Pressed button to add ingredient")
        let action = UIAction {[weak self] _ in self?.addIngredient() }
        button.addAction(action, for: .primaryActionTriggered)
        button.accessibilityIdentifier = "Add"
        return button
    }()

    let inputIngredient: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Lemon, Cheese..."
        textField.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .title3)
        textField.textAlignment = .left
        textField.textColor = .darkGray
        textField.setAccessibility(with: .searchField, label: "input Ingredients", hint: "Area to input your ingredient")
        textField.accessibilityIdentifier = "inputTextFields"
        return textField
    }()

    let underligne: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let clearStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    let yourIngredientsLabel: UILabel = {
       let label = UILabel()
        label.text = "Your ingredients :"
        label.setupDynamicTextWith(policeName: "Chalkduster", size: 23, style: .largeTitle)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()

    lazy var clearIngredients: UIButton = {
        let button = UIButton()
        button.setTitle(" Clear ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.backgroundColor = .darkGray
        button.setupDynamicTextWith(style: .body)
        button.layer.cornerRadius = 5
        button.setAccessibility(with: .button, label: "clear ingredient", hint: "Pressed button to clear ingredient")
        let action = UIAction {[weak self] _ in self?.clearIngredient() }
        button.addAction(action, for: .primaryActionTriggered)
        button.accessibilityIdentifier = "Clear"
        return button
    }()

    let ingredientListView: UITextView = {
       let texte = UITextView()
        texte.textColor = .white
        texte.backgroundColor = .anthraciteGray
        texte.isEditable = false
        texte.setupDynamicTextWith(policeName: "Chalkduster", size: 23, style: .largeTitle)
        texte.setAccessibility(with: .staticText, label: "ingredient", hint: "Ingredient in your liste")
        return texte
    }()

    lazy var searchRecipes: UIButton = {
        let button = UIButton()
        button.setTitle("Search for recipes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGreen
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .footnote)
        button.layer.cornerRadius = 5
        button.setAccessibility(with: .button, label: "search for recipes", hint: "Pressed button to search recipes with ingredients")
        let action = UIAction {[weak self] _ in self?.searchRecip() }
        button.addAction(action, for: .primaryActionTriggered)
        button.accessibilityIdentifier = "searchButton"
        return button
    }()

    // MARK: - Proprietie
    private let viewModel = SearchViewModel()

    // MARK: - Cycle of life
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationBar()

        setupUI()
        setupContraints()

        updateDisplayAccessibility()
        setupTapGesture()

        inputIngredient.delegate = self

        setupBinding()
    }

    // MARK: - Layout
    private func setupUI() {
        [searchStackView,
         questionTitle,
         addIngredients,
         inputIngredient,
         underligne,
         inputStackView, searchRecipes, searchArea,
         clearStackView, yourIngredientsLabel, clearIngredients, ingredientListView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(searchArea)
        searchArea.addSubview(searchStackView)

        searchStackView.addArrangedSubview(questionTitle)
        searchStackView.addArrangedSubview(inputStackView)

        inputStackView.addArrangedSubview(inputIngredient)
        inputStackView.addArrangedSubview(addIngredients)

        searchStackView.addSubview(underligne)

        view.addSubview(clearStackView)
        clearStackView.addArrangedSubview(yourIngredientsLabel)
        clearStackView.addArrangedSubview(clearIngredients)

        view.addSubview(searchRecipes)
        view.addSubview(ingredientListView)
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            searchArea.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchArea.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchArea.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            searchStackView.leftAnchor.constraint(equalTo: searchArea.leftAnchor, constant: 10),
            searchStackView.rightAnchor.constraint(equalTo: searchArea.rightAnchor, constant: -10),
            searchStackView.topAnchor.constraint(equalTo: searchArea.topAnchor, constant: 10),
            searchArea.bottomAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 15)
        ])

        NSLayoutConstraint.activate([
            underligne.heightAnchor.constraint(equalToConstant: 1),
            underligne.leftAnchor.constraint(equalTo: inputIngredient.leftAnchor),
            underligne.rightAnchor.constraint(equalTo: inputIngredient.rightAnchor),
            underligne.topAnchor.constraint(equalTo: inputIngredient.bottomAnchor, constant: 5)
        ])

        NSLayoutConstraint.activate([
            clearStackView.topAnchor.constraint(equalTo: searchArea.bottomAnchor, constant: 10),
            clearStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            clearStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            clearIngredients.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            addIngredients.widthAnchor.constraint(equalTo: clearIngredients.widthAnchor),
            addIngredients.heightAnchor.constraint(equalTo: clearIngredients.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            searchRecipes.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchRecipes.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            searchRecipes.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            searchRecipes.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            ingredientListView.topAnchor.constraint(equalTo: clearStackView.bottomAnchor, constant: 10),
            ingredientListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            ingredientListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            ingredientListView.bottomAnchor.constraint(equalTo: searchRecipes.topAnchor, constant: -10)
        ])
    }

    // MARK: - Binding
    private func setupBinding() {
        viewModel.$ingredientList
            .sink { [weak self] newValue in
                self?.ingredientListView.text = newValue
                self?.ingredientListView.accessibilityValue = newValue
            }
            .store(in: &cancellables)
    }
}

// MARK: - Add action button
extension SearchController {
    private func addIngredient() {
        viewModel.addIngredient(inputIngredient.text)
        inputIngredient.text = ""
        dismissKeyboard()
    }

    private func clearIngredient() {
        viewModel.clearIngredientList()
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

    private func updateDisplayAccessibility() {
        let currentCategory = traitCollection.preferredContentSizeCategory
        let isAccessibilityCategory = currentCategory.isAccessibilityCategory

        inputStackView.axis = isAccessibilityCategory ? .vertical : .horizontal
        inputIngredient.placeholder = isAccessibilityCategory ? "ingredient" : "Lemon, Cheese..."
        searchRecipes.setTitle(isAccessibilityCategory ? "Search" : "Search for recipes", for: .normal)
        questionTitle.isHidden = isAccessibilityCategory
        underligne.isHidden = isAccessibilityCategory
        yourIngredientsLabel.isHidden = isAccessibilityCategory
    }
}

// MARK: - TextField
extension SearchController: UITextFieldDelegate {

    @objc func dismissKeyboard() {
        inputIngredient.resignFirstResponder()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputIngredient.resignFirstResponder()
        addIngredient()
        return true
    }
}

// MARK: - Search Button
extension SearchController {
    private func searchRecip() {
        guard !viewModel.ingredients.isEmpty else {return}

        let newController = ResultSearchViewController(context: .search(ingredients: viewModel.ingredients))
        newController.title = "Reciplease"
        self.navigationController?.pushViewController(newController, animated: true)
    }
}

// MARK: - TapGesture
extension SearchController {
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
}
