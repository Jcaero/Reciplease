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

    let labelView =  GradientView(with: .clear, color2: .black)

    let titleLabel: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .headline)
        label.textColor = .white
        label.textAlignment = .center
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

    let ingredientListView: UITextView = {
       let texte = UITextView()
        texte.textColor = .white
        texte.backgroundColor = .anthraciteGray
        texte.isEditable = false
        texte.setupDynamicTextWith(policeName: "Chalkduster", size: 23, style: .largeTitle)
        texte.setAccessibility(with: .staticText, label: "ingredients", hint: "liste of Ingredients")
        return texte
    }()

    lazy var getDirectionsButton : UIButton = {
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
    }

    // MARK: - Function
    private func setupView() {
        [backGroundImage,
         labelView, titleLabel,
         ingredient,
         ingredientListView,
         getDirectionsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(backGroundImage)
        NSLayoutConstraint.activate([
            backGroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backGroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backGroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
        
        view.addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.leftAnchor.constraint(equalTo: view.leftAnchor),
            labelView.rightAnchor.constraint(equalTo: view.rightAnchor),
            labelView.bottomAnchor.constraint(equalTo: backGroundImage.bottomAnchor)
        ])

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: labelView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: labelView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor)
        ])
        
    }
}
