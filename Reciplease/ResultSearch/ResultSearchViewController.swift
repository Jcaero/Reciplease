//
//  ResultSearchViewController.swift
//  Reciplease
//
//  Created by pierrick viret on 30/09/2023.
//

import UIKit

class ResultSearchViewController: UIViewController {

    private var ingredients: [String] = []
    private let viewModel = ResultSearchViewModel()

    // MARK: - liste of UI
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    // MARK: - Init
    init(ingredients: [String] = []) {
        super.init(nibName: nil, bundle: nil)
        self.ingredients = ingredients
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cicle life
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .anthraciteGray
        setupIndicator()
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchInitRecipes(with: ingredients)
    }

    // MARK: - Setup Function

    private func setupIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
