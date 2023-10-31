//
//  ResultSearchViewController.swift
//  Reciplease
//
//  Created by pierrick viret on 30/09/2023.
//

import UIKit
import Combine

class ResultSearchViewController: ViewController {

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
        tableView.backgroundColor = .anthraciteGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Properties
    enum Context {
        case search(ingredients: [String])
        case favorite
    }

    private var context: ResultSearchViewController.Context
    private let viewModel = ResultSearchViewModel()

    // MARK: - Init
    init(context: ResultSearchViewController.Context) {
        self.context = context
        super.init()
        setupUI()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        switch context {
        case .search(let ingredients):
            viewModel.fetchInitRecipes(with: ingredients)
        case .favorite:
            initNavigationBar()
            viewModel.fetchSaveRecipes()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Function
    private func setupUI() {
        view.addSubview(activityIndicator)
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

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
                guard response != false, let self = self else { return }
                self.updateTableView()
            }.store(in: &cancellables)

        viewModel.$alerteMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                guard response != nil, let self = self else { return }
                self.tableView.isHidden = true
                self.activityIndicator.stopAnimating()
                self.returnAndShowSimpleAlerte(with: response!)
            }.store(in: &cancellables)
    }

    private func updateTableView() {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }

    private func returnAndShowSimpleAlerte(with error: ErrorMessage) {
        let alertVC = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        return self.present(alertVC, animated: true, completion: nil)
    }

    private func showSimpleAlerte(with error: ErrorMessage) {
        let alertVC = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
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
        let recipe = viewModel.recipes[indexPath.row]
        cell.setupCell(with: recipe)
        cell.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cell.accessibilityIdentifier = recipe.label
        return cell
    }
}

extension ResultSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newController = DetailController(with: viewModel.recipes[indexPath.row])
        newController.title = "Reciplease"
        self.navigationController?.pushViewController(newController, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
            self.recipeSaveManager.deleteRecipe(self.viewModel.recipes[indexPath.row])
            self.viewModel.recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        let saveItem = UIContextualAction(style: .normal, title: "Save") {  (_, _, _) in
            let recipe = self.viewModel.recipes[indexPath.row]
            self.recipeSaveManager.saveRecipe(named: recipe, image: nil)
            recipe.isSave = true
        }
        saveItem.backgroundColor = .blue

        switch context {
        case .favorite: return UISwipeActionsConfiguration(actions: [deleteItem])
        default: return UISwipeActionsConfiguration(actions: [saveItem])
        }
  }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        switch context {
        case .favorite: if indexPath.row == (viewModel.recipes.count - 1) && viewModel.isNetworkSuccessful == true {
            viewModel.fetchMoreRecipes()
        }
        default: break
        }
    }
}
