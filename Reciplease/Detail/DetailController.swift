//
//  DetailController.swift
//  Reciplease
//
//  Created by pierrick viret on 13/10/2023.
//

import UIKit

class DetailController: ViewController {

    // MARK: - liste of UI
    let backGroundImage: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_non_dispo")
        return imageView
    }()

    let gradientView =  GradientView(with: .clear, color2: .black)

    var infoStackView = InfoStackView(texteSize: 20)

    let titleLabel: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .headline)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setAccessibility(with: .header, label: "Recipe Title", hint: "title of the recipe")
        return label
    }()

    let ingredientLabel: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Chalkduster", size: 25, style: .body)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Ingredients"
        label.setAccessibility(with: .header, label: "ingredients", hint: "ingredients of the recipe")
        return label
    }()

    let ingredientListView: UITextView = {
       let texte = UITextView()
        texte.textColor = .white
        texte.backgroundColor = .anthraciteGray
        texte.isEditable = false
        texte.setupDynamicTextWith(policeName: "Chalkduster", size: 18, style: .largeTitle)
        texte.setAccessibility(with: .staticText, label: "ingredients", hint: "liste of Ingredients")
        return texte
    }()

    lazy var getDirectionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get directions", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGreen
        button.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .footnote)
        button.layer.cornerRadius = 5
        button.setAccessibility(with: .button, label: "go to detail liste of recipes", hint: "Pressed button to go to detail liste of recipes")
       // button.addTarget(self, action: #selector(??), for: .touchUpInside)
        button.accessibilityIdentifier = "getDirectionsButton"
        return button
    }()

    // MARK: - Cycle of life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateDisplayAccessibility()
    }

    init(with recipe: Recipe) {
        super.init()
        backGroundImage.downloadImageWith(recipe.images.regular.url)
        titleLabel.text = recipe.label
        ingredientListView.text =  "- " + recipe.ingredientLines.joined(separator: "\n- ")
        infoStackView.setup(with: recipe.totalTime, yield: recipe.yield)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Function
    private func setupView() {
        [backGroundImage,
         infoStackView,
         gradientView, titleLabel,
         ingredientLabel,
         ingredientListView,
         getDirectionsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(backGroundImage)
        NSLayoutConstraint.activate([
            backGroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backGroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backGroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImage.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.4)
        ])

        view.addSubview(infoStackView)
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            infoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            infoStackView.widthAnchor.constraint(equalTo: infoStackView.heightAnchor),
            infoStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])

        view.addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: view.rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: backGroundImage.bottomAnchor),
            gradientView.topAnchor.constraint(greaterThanOrEqualTo: infoStackView.bottomAnchor, constant: 5),
            gradientView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])

        gradientView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: gradientView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: gradientView.rightAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: gradientView.topAnchor, constant: -5)
        ])

        view.addSubview(getDirectionsButton)
        NSLayoutConstraint.activate([
            getDirectionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getDirectionsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            getDirectionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            getDirectionsButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])

        view.addSubview(ingredientLabel)
        NSLayoutConstraint.activate([
            ingredientLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            ingredientLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            ingredientLabel.topAnchor.constraint(equalTo: backGroundImage.bottomAnchor, constant: 10)
        ])

        view.addSubview(ingredientListView)
        NSLayoutConstraint.activate([
            ingredientListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            ingredientListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            ingredientListView.topAnchor.constraint(equalTo: ingredientLabel.bottomAnchor, constant: 10),
            ingredientListView.bottomAnchor.constraint(equalTo: getDirectionsButton.topAnchor, constant: -10)
        ])
    }
}

// MARK: - Accessibility
extension DetailController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let currentCategory = traitCollection.preferredContentSizeCategory
        let previousCategory = previousTraitCollection?.preferredContentSizeCategory

        guard currentCategory != previousCategory else { return }
        updateDisplayAccessibility()
    }

    private func updateDisplayAccessibility() {
        let currentCategory = traitCollection.preferredContentSizeCategory

        if currentCategory.isAccessibilityCategory {
            getDirectionsButton.setTitle("Directions", for: .normal)
//            infoStackView.isHidden = true
            ingredientLabel.isHidden = true
        } else {
            getDirectionsButton.setTitle("Get directions", for: .normal)
//            infoStackView.isHidden = false
            ingredientLabel.isHidden = false
        }
    }
}
