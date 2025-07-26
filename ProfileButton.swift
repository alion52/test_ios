//
//  ProfileButton.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import UIKit

final class ProfileButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        setImage(UIImage(systemName: "person.circle"), for: .normal)
        tintColor = .black
    }
}
