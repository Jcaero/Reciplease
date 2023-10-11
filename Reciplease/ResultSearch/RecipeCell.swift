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
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.spacing = 5
        return stackView
    }()

    let timeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
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

    let labelView: UIView = {
        let view = UIView()
        return view
    }()

    let backGroundImage: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_non_dispo")
        return imageView
    }()

    // MARK: - Properties
    static let reuseIdentifier = "RecipeCell"
    let gradientLayer = CAGradientLayer()

    // MARK: - cycle life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        self.backgroundColor = .anthraciteGray
        setupGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = labelView.bounds
    }

    // MARK: - Fonction
    private func setupUI() {
        [title,
         ingredient,
         infoStackView,
         timeStackView, time, clock,
         rateStackView, rate, thumb,
         labelView].forEach {
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
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            infoStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            infoStackView.widthAnchor.constraint(equalTo: infoStackView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            clock.heightAnchor.constraint(equalTo: time.heightAnchor),
            clock.widthAnchor.constraint(equalTo: thumb.widthAnchor),
            clock.widthAnchor.constraint(equalTo: clock.heightAnchor),
            thumb.widthAnchor.constraint(equalTo: thumb.heightAnchor)
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
        if recipe.totalTime >= 60 {
            time.text = String(recipe.totalTime / 60) + "h"
        } else {
            time.text = String(recipe.totalTime) + "m"
        }
        rate.text = "10k"
        backGroundImage.downloadImageWith(recipe.images.regular.url)
        backgroundView = backGroundImage
    }

    private func setupGradient() {
        gradientLayer.colors = [UIColor.clear, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        labelView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
