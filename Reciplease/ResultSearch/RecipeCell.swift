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

    var infoStackView = InfoStackView(texteSize: 15)

    let labelView = GradientView(with: .clear, color2: .black)

    let backGroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_non_dispo")
        return imageView
    }()

    // MARK: - Properties
    static let reuseIdentifier = "RecipeCell"

    var cancellables = Set<AnyCancellable>()
    private var imageRepository = DownloadImage()

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

    func setupCell(with recipe: LocalRecipe) {
        title.text = recipe.label
        ingredient.text = recipe.listeOfIngredients
        infoStackView.setup(with: Int(recipe.totalTime), yield: Int(recipe.yield))

        setupImageRecip(of: recipe)
    }

    private func setupImageRecip(of recipe: LocalRecipe) {
        if let image = recipe.image {
            print("save image")
            showImage(image: image)
        } else if !recipe.imageUrl.isEmpty {
            downloadRecipeImage(recipe.imageUrl)
        }
    }

    private func downloadRecipeImage(_ imageUrl: String) {
        imageRepository.downloadImageWith(imageUrl)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case.finished:
                    break
                case .failure(let error):
                    print("erreur de telechargement d'image \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] image in
                guard let self = self else {return }
                showImage(image: image)
            }.store(in: &cancellables)
    }

    private func showImage( image: UIImage) {
        self.backGroundImage.image = image
        self.backgroundView = backGroundImage
    }
}
