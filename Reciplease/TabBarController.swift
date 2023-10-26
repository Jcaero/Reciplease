//
//  TabBarController.swift
//  Reciplease
//
//  Created by pierrick viret on 22/09/2023.
//

import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
        setupTabBar()
    }

    func setupVCs() {
        let searchController = UINavigationController(rootViewController: SearchController())
        let favoriteController = UINavigationController(rootViewController: ResultSearchViewController(context: .favorite) )

        searchController.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 0)
        searchController.tabBarItem.accessibilityHint = "appuyer pour afficher la page de recherche"
        favoriteController.tabBarItem = UITabBarItem(title: "Favorite", image: nil, tag: 1)
        searchController.tabBarItem.accessibilityHint = "appuyer pour afficher la page des Favoris"

        viewControllers = [searchController, favoriteController]

    }

    func setupTabBar() {

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .anthraciteGray

        // setup offset if iPhone SE
        var offset = 0
        if UIScreen.main.bounds.size.height == 667 {
            offset = 10
        }

        // setup normal Attributes
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Chalkduster", size: 25)!,
            .baselineOffset: offset
        ]

        // setup selected Attributes
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .baselineOffset: offset
        ]

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance

        // create ligne betwen item
        let topline = CALayer()
        topline.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 2)
        topline.backgroundColor = UIColor.gray.cgColor
        self.tabBar.layer.addSublayer(topline)

        let firstVerticalLine = CALayer()
        firstVerticalLine.frame = CGRect(x: self.tabBar.frame.width / 2, y: 0, width: 2, height: (self.tabBar.frame.height + 34))
        firstVerticalLine.backgroundColor = UIColor.gray.cgColor
        self.tabBar.layer.addSublayer(firstVerticalLine)
    }
}
