//
//  CategotiesCell.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 25.07.25.
//
import UIKit

class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with title: String, isSelected: Bool) {
        label.text = title
        contentView.backgroundColor = isSelected ? .orange : .systemGray5
        contentView.layer.cornerRadius = 8
    }
}
