//
//  InfoStackView.swift
//  Reciplease
//
//  Created by pierrick viret on 13/10/2023.
//

import UIKit

class InfoStackView: UIStackView {
    let timeLabel: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.setAccessibility(with: .header, label: "time", hint: "duration of the recipe")
        return label
    }()

    let yieldLabel: UILabel = {
       let label = UILabel()
        label.setupDynamicTextWith(policeName: "Symbol", size: 15, style: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.setAccessibility(with: .header, label: "yield", hint: "yield of the recipe")
        return label
    }()

    let fork: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "fork.knife")
        image.tintColor = .white
        return image
    }()

    let clock: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "clock")
        image.tintColor = .white
        return image
    }()

    let yieldStackView: UIStackView = {
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

    // MARK: - INIT
    init() {
        super.init(frame: .zero)
        self.initStack()
        self.setupUI()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Function
    func setup(with time: Int, yield: Int) {
        if time >= 60 {
            timeLabel.text = String(time / 60) + "h"
        } else {
            timeLabel.text = String(time) + "m"
        }
        yieldLabel.text = String(yield)
    }

    private func initStack() {
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 10
        self.layer.cornerRadius = 5
        self.backgroundColor = .anthraciteGray

        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.isLayoutMarginsRelativeArrangement = true
    }

    private func setupUI() {
        [timeStackView, timeLabel, clock,
         yieldStackView, yieldLabel, fork].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        self.addArrangedSubview(yieldStackView)
        self.addArrangedSubview(timeStackView)
        yieldStackView.addArrangedSubview(yieldLabel)
        yieldStackView.addArrangedSubview(fork)
        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(clock)

        NSLayoutConstraint.activate([
            clock.heightAnchor.constraint(equalTo: timeLabel.heightAnchor),
            clock.widthAnchor.constraint(equalTo: fork.widthAnchor),
            clock.widthAnchor.constraint(equalTo: clock.heightAnchor),
            fork.widthAnchor.constraint(equalTo: fork.heightAnchor)
        ])
    }

}
