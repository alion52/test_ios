//
//  Product.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 23.07.25.
//
import Foundation

struct Product: Codable {
    let id: String
    let name: String
    let descriptionText: String
    let price: Double
    let imageName: String
    let discount: String?
    
    var formattedPrice: String {
        return "от \(Int(price)) р"
    }
}
