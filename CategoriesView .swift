//
//  CategoriesView .swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 23.07.25.
//
import UIKit

class CategoriesView: UIView {
    private var buttons: [UIButton] = []
    var didSelectCategory: ((Int) -> Void)?
    
    func configure(with categories: [String]) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillProportionally
        
        for (index, category) in categories.enumerated() {
            let button = UIButton()
            button.setTitle(category, for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.tag = index
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func selectCategory(at index: Int) {
        buttons.forEach { $0.isSelected = false }
        buttons[index].isSelected = true
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        selectCategory(at: sender.tag)
        didSelectCategory?(sender.tag)
    }
}
