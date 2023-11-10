//
//  DetailController.swift
//  Reciplease
//
//  Created by pierrick viret on 13/10/2023.
//

import UIKit
import Combine

class DetailController: ViewController {

    // MARK: - liste of UI
    let recipImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_non_dispo")
        return imageView
    }()

    let titleStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    let gradientView =  GradientView(with: .clear, color2: .black)

    let infoView = UIView()

    var infoStackView = InfoStackView(texteSize: 20)

    let titleLabel: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .headline)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
        label.setAccessibility(with: .header, label: "Recipe Title", hint: "title of the recipe")
        return label
    }()

    let ingredientListeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
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
        texte.setupDynamicTextWith(policeName: "Chalkduster", size: 18, style: .caption1)
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
        let action = UIAction {[weak self] _ in self?.getDirection() }
        button.addAction(action, for: .primaryActionTriggered)
        button.accessibilityIdentifier = "getDirectionsButton"
        return button
    }()

    // MARK: - Properties
    private var isStarFilled = false {
        didSet {
            isStarFilled ? setStarWith(filledStarImage)  : setStarWith(emptyStarImage)
        }
    }

    let emptyStarImage = UIImage(systemName: "star")!
    let filledStarImage = UIImage(systemName: "star.fill")!

    private var recipe: LocalRecipe!

    private var imageRepository = DownloadImage()

    // MARK: - Cycle of life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContraints()
        setupStar()
        updateDisplayAccessibility()
    }

    override func viewWillAppear(_ animated: Bool) {
        isStarFilled = recipeSaveManager.isSaveRecipeContains(recipe)
    }

    init(with recipe: LocalRecipe) {
        super.init()
        self.recipe = recipe

        setTitleText()
        setTextInTextView(withYield: false)
        infoStackView.setup(with: Int(recipe.totalTime), yield: Int(recipe.yield))

        isStarFilled = recipe.isSave

        setupImageRecip(of: recipe)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Function
    private func setupUI() {
        [recipImage,
         ingredientListeStackView,
         titleStackView, infoView,
         infoStackView,
         gradientView, titleLabel,
         ingredientLabel,
         ingredientListView,
         getDirectionsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(recipImage)
        infoView.addSubview(infoStackView)

        view.addSubview(titleStackView)
        titleStackView.addArrangedSubview(infoView)
        titleStackView.addArrangedSubview(gradientView)

        gradientView.addSubview(titleLabel)
        view.addSubview(getDirectionsButton)
        view.addSubview(ingredientListeStackView)
        ingredientListeStackView.addArrangedSubview(ingredientLabel)
        ingredientListeStackView.addArrangedSubview(ingredientListView)
    }

    private func setupContraints() {

        NSLayoutConstraint.activate([
            recipImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            recipImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            recipImage.topAnchor.constraint(equalTo: view.topAnchor),
            recipImage.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.3)
        ])

        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: infoView.topAnchor),
            infoStackView.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10),
            infoStackView.widthAnchor.constraint(equalTo: infoStackView.heightAnchor),
            infoStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),
            infoView.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            titleStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            titleStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: recipImage.bottomAnchor),
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: gradientView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: gradientView.rightAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: gradientView.topAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            getDirectionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getDirectionsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            getDirectionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            getDirectionsButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            ingredientListeStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            ingredientListeStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ingredientListeStackView.topAnchor.constraint(equalTo: recipImage.bottomAnchor, constant: 5),
            ingredientListeStackView.bottomAnchor.constraint(equalTo: getDirectionsButton.topAnchor, constant: -5)
        ])
    }

    // MARK: - Star saver
    func setupStar() {
        let starButton = UIBarButtonItem(image: emptyStarImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(starButtonTapped))
        starButton.tintColor = .darkGreen
        starButton.accessibilityIdentifier = "SaveButtonStar"
        starButton.customView?.setAccessibility(with: .button, label: "Save Recipe", hint: "tap to save recipe")
        self.navigationItem.rightBarButtonItem = starButton
        if recipe.isSave == true {
            self.setStarWith(filledStarImage)
        }
    }

    func setStarWith(_ image: UIImage) {
        self.navigationItem.rightBarButtonItem?.image = image
    }

    // MARK: - manage Image
    private func setupImageRecip(of recipe: LocalRecipe) {
        if let image = recipe.image {
            self.recipImage.image = image
        } else if !recipe.imageUrl.isEmpty {
            downloadRecipeImage(recipe.imageUrl)
        }
    }

    private func downloadRecipeImage(_ imageUrl: String) {
        imageRepository.downloadImageWith(recipe.imageUrl)
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
                self.recipImage.image = image
            }.store(in: &cancellables)
    }

    // MARK: - Text
    private func setTextInTextView(withYield result: Bool) {
        let normalText = "- " + recipe.listeOfIngredientsWithDetail.joined(separator: "\n- ")

        let totalTime = recipe.totalTime == 0 ? "UNK" : String(recipe.totalTime)
        let accessibilityText = """
                                Yield = \(recipe.yield)
                                Total Time = \(totalTime)

                                Ingredients
                                \(normalText)
                                """

        ingredientListView.text = result ? accessibilityText : normalText
    }

    private func setTitleText() {
        titleLabel.text = recipe.label
        titleLabel.accessibilityValue = titleLabel.text
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
            ingredientLabel.isHidden = true
            infoView.isHidden = true
            setTextInTextView(withYield: true)
            switch currentCategory {
            case .accessibilityExtraExtraExtraLarge:
                titleLabel.setupDynamicTextWith(policeName: "Symbol", size: 19, style: .caption2)
            case .accessibilityExtraExtraLarge:
                titleLabel.setupDynamicTextWith(policeName: "Symbol", size: 23, style: .caption1)
            default:
                titleLabel.setupDynamicTextWith(policeName: "Symbol", size: 25, style: .caption1)
            }

        } else {
            getDirectionsButton.setTitle("Get directions", for: .normal)
            ingredientLabel.isHidden = false
            infoView.isHidden = false
            setTextInTextView(withYield: false)
            titleLabel.setupDynamicTextWith(policeName: "Symbol", size: 30, style: .headline)
        }
    }
}

// MARK: - Core Data
extension DetailController {
    @objc func starButtonTapped() {

        isStarFilled.toggle()

        if isStarFilled {
            recipeSaveManager.saveRecipe(named: recipe, image: recipImage.image!)
            recipe.isSave = true
            self.navigationItem.rightBarButtonItem?.image = filledStarImage
        } else {
            recipeSaveManager.deleteRecipe(recipe)
            recipe.isSave = false
            self.navigationItem.rightBarButtonItem?.image = emptyStarImage
        }
    }
}

// MARK: - GetDirections buttons

extension DetailController {
    private func getDirection() {
        guard let url = URL(string: self.recipe.sourceUrl) else { return }
        UIApplication.shared.open(url)
    }
}
