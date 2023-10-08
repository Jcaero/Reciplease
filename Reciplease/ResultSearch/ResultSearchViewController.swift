//
//  ResultSearchViewController.swift
//  Reciplease
//
//  Created by pierrick viret on 30/09/2023.
//

import UIKit
import Combine

class ResultSearchViewController: UIViewController {

    private var ingredients: [String] = []
    private let viewModel = ResultSearchViewModel()
    var cancellables = Set<AnyCancellable>()

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
        return tableView
    }()

    // MARK: - Init
    init(ingredients: [String] = []) {
        super.init(nibName: nil, bundle: nil)
        self.ingredients = ingredients
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Cycle of life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIndicator()
        viewModel.$isLoading
            .sink { [weak self] response in
                if response == false {
                    self?.setupTableView()
                }
            }.store(in: &cancellables)
        
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

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension ResultSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeCell else {
            print("erreur de cell")
            return UITableViewCell()
        }
        cell.setupCell(with: viewModel.recipes[indexPath.row].recipe)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
