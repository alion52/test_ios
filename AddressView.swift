//
//  AddressView.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import UIKit

final class AddressView: UIView {
    private let label = UILabel()
    private let icon = UIImageView()
    
    func configure(address: String) {
        label.text = address
    }
}
