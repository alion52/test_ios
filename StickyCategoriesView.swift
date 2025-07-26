//
//  StickyCategoriesView.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import UIKit

final class StickyCategoriesView: UIView {
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(categories: [String]) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []
        
        categories.enumerated().forEach { index, category in
            let button = UIButton()
            button.setTitle(category, for: .normal)
            button.setTitleColor(index == 0 ? .systemRed : .gray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    func selectCategory(at index: Int) {
        buttons.enumerated().forEach { i, button in
            button.setTitleColor(i == index ? .systemRed : .gray, for: .normal)
        }
    }
}
