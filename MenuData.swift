//
//  MenuData.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import Foundation

struct MenuResponse: Codable {
    let categories: [Category]
    let productsByCategory: [String: [Product]]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categories = try container.decode([Category].self, forKey: .categories)
        productsByCategory = try container.decode([String: [Product]].self, forKey: .productsByCategory)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categories, forKey: .categories)
        try container.encode(productsByCategory, forKey: .productsByCategory)
    }
    
    enum CodingKeys: String, CodingKey {
        case categories
        case productsByCategory = "products_by_category"
    }
}
