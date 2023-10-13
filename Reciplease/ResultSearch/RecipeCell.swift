//
//  RecipCell.swift
//  Reciplease
//
//  Created by pierrick viret on 03/10/2023.
//

import UIKit
import Combine

class RecipeCell: UITableViewCell {

    // MARK: - liste of UI
    let title: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .headline)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "Recipe Title", hint: "title of the recipe")
        return label
    }()

    let ingredient: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setAccessibility(with: .header, label: "ingredients", hint: "ingredients of the recipe")
        return label
    }()

    var infoStackView = InfoStackView()

    let labelView = GradientView(with: .clear, color2: .black)

    let backGroundImage: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_non_dispo")
        return imageView
    }()

    // MARK: - Properties
    static let reuseIdentifier = "RecipeCell"

    // MARK: - cycle life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .anthraciteGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Fonction
    private func setupUI() {
        [title,
         ingredient,
         infoStackView,
         labelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(infoStackView)
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            infoStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            infoStackView.widthAnchor.constraint(equalTo: infoStackView.heightAnchor)
        ])

        addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor),
            labelView.leftAnchor.constraint(equalTo: leftAnchor),
            labelView.rightAnchor.constraint(equalTo: rightAnchor),
            labelView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        labelView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 15),
            title.leftAnchor.constraint(equalTo: labelView.leftAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: labelView.rightAnchor, constant: -10)
        ])

        labelView.addSubview(ingredient)
        NSLayoutConstraint.activate([
            ingredient.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            ingredient.leftAnchor.constraint(equalTo: title.leftAnchor),
            ingredient.rightAnchor.constraint(equalTo: title.rightAnchor),
            ingredient.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -10)
        ])
    }

    func setupCell(with recipe: Recipe) {
        title.text = recipe.label
        let text = recipe.ingredients.reduce("") { partialResult, ingredient in
            if partialResult == "" {
                partialResult + ingredient.food
            } else {
                partialResult + ", " + ingredient.food
            }
        }

        ingredient.text = text
        infoStackView.setup(with: recipe.totalTime, yield: recipe.yield)
        backGroundImage.downloadImageWith(recipe.images.regular.url)
        backgroundView = backGroundImage
    }
}
