//
//  RecipCell.swift
//  Reciplease
//
//  Created by pierrick viret on 03/10/2023.
//

import UIKit

class RecipCell: UITableViewCell {

    // MARK: - liste of UI
    let title: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .headline)
        label.textColor = .white
        label.textAlignment = .left
        label.setAccessibility(with: .header, label: "Recipe Title", hint: "title of the recipe")
        return label
    }()

    let ingredient: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 10, style: .body)
        label.textColor = .white
        label.textAlignment = .left
        label.setAccessibility(with: .header, label: "ingredients", hint: "ingredients of the recipe")
        return label
    }()

    let time: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 10, style: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.setAccessibility(with: .header, label: "time", hint: "duration of the recipe")
        return label
    }()

    let rate: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 10, style: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.setAccessibility(with: .header, label: "rate", hint: "rate of the recipe")
        return label
    }()

    let thumb: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "hand.thumbsup")
        return image
    }()

    let clock: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "clock")
        return image
    }()

    let rateStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    let timeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    let infoStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 5
        stackView.backgroundColor = .anthraciteGray
        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.layer.borderWidth = 1
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [title, ingredient, time, rate, thumb, clock, backGroundImage, infoStackView, timeStackView, rateStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(ingredient)
        NSLayoutConstraint.activate([
            ingredient.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            ingredient.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            ingredient.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])

        addSubview(title)
        NSLayoutConstraint.activate([
            ingredient.bottomAnchor.constraint(equalTo: ingredient.topAnchor, constant: -5),
            ingredient.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            ingredient.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])

        addSubview(infoStackView)
        infoStackView.addArrangedSubview(rateStackView)
        infoStackView.addArrangedSubview(timeStackView)
        rateStackView.addArrangedSubview(rate)
        rateStackView.addArrangedSubview(thumb)
        timeStackView.addArrangedSubview(time)
        timeStackView.addArrangedSubview(clock)

        NSLayoutConstraint.activate([
            ingredient.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            ingredient.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -10),
            ingredient.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }

    func setupCell(with recipe: Recipe) {
        title.text = recipe.label
        ingredient.text = recipe.ingredientLines[0]
        time.text = String(recipe.totalTime)
        rate.text = "10k"
    }
}
