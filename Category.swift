//
//  Categoty.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import Foundation

struct Category: Codable, Hashable {
    let id: String
    let name: String
    let imageUrl: String?
}
