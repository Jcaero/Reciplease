//
//  RecipCell.swift
//  Reciplease
//
//  Created by pierrick viret on 03/10/2023.
//

import UIKit

class RecipeCell: UITableViewCell {

    // MARK: - liste of UI
    let title: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .headline)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setAccessibility(with: .header, label: "Recipe Title", hint: "title of the recipe")
        return label
    }()

    let ingredient: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .white
        label.textAlignment = .left
        label.setAccessibility(with: .header, label: "ingredients", hint: "ingredients of the recipe")
        return label
    }()

    let time: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.setAccessibility(with: .header, label: "time", hint: "duration of the recipe")
        return label
    }()

    let rate: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.setAccessibility(with: .header, label: "rate", hint: "rate of the recipe")
        return label
    }()

    let thumb: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "hand.thumbsup.fill")
        image.tintColor = .white
        return image
    }()

    let clock: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "clock")
        image.tintColor = .white
        return image
    }()

    let rateStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline
        stackView.spacing = 5
        return stackView
    }()

    let timeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .firstBaseline
        stackView.spacing = 5
        return stackView
    }()

    let infoStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.layer.cornerRadius = 5
        stackView.backgroundColor = .anthraciteGray

        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.layer.borderWidth = 1
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        stackView.isLayoutMarginsRelativeArrangement = true

        return stackView
    }()

    let backGroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .anthraciteGray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [title,
         ingredient,
         infoStackView,
         timeStackView, time, clock,
         rateStackView, rate, thumb,
         backGroundImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(infoStackView)
        infoStackView.addArrangedSubview(rateStackView)
        infoStackView.addArrangedSubview(timeStackView)
        rateStackView.addArrangedSubview(rate)
        rateStackView.addArrangedSubview(thumb)
        timeStackView.addArrangedSubview(time)
        timeStackView.addArrangedSubview(clock)

        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            infoStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            infoStackView.widthAnchor.constraint(equalTo: infoStackView.heightAnchor)
        ])

        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 5),
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])

        addSubview(ingredient)
        NSLayoutConstraint.activate([
            ingredient.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            ingredient.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            ingredient.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }

    func setupCell(with recipe: Recipe) {
        title.text = recipe.label
        ingredient.text = recipe.ingredients[0].food
        time.text = String(recipe.totalTime)
        rate.text = "10k"
    }
}
