//
//  ViewController.swift
//  Reciplease
//
//  Created by pierrick viret on 21/09/2023.
//

import Combine
import UIKit

class ViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()
    let recipeSaveManager = RecipeSaveManager()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .anthraciteGray
    }

    // MARK: - Init navigationBar
    func initNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .anthraciteGray
        appearance.titleTextAttributes = [.font: UIFont(name: "Chalkduster", size: 25)!,
                                          .foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance

        navigationController?.navigationBar.topItem?.title = "Reciplease"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
}
