//
//  ResultSearchViewController.swift
//  Reciplease
//
//  Created by pierrick viret on 30/09/2023.
//

import UIKit
import Combine

class ResultSearchViewController: ViewController {

    private var ingredients: [String]
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

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "RecipeCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        return tableView
    }()

    // MARK: - Init
    init(ingredients: [String]) {
        self.ingredients = ingredients
        super.init()
        setupTableView()
        setupIndicator()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Function
    private func setupIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .anthraciteGray

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func setupBinding() {
        viewModel.$isNetworkSuccessful
            .receive(on: RunLoop.main)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] response in
                guard response != nil else { return }
                self?.updateTableView()
            }.store(in: &cancellables)

        viewModel.$isAlerte
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                guard response == true else { return }
                print("non recip")
            }.store(in: &cancellables)

        viewModel.fetchInitRecipes(with: ingredients)
    }

    private func updateTableView() {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ResultSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as? RecipeCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        let recipe = viewModel.recipes[indexPath.row].recipe
        cell.setupCell(with: recipe)
        return cell
    }
}

extension ResultSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
