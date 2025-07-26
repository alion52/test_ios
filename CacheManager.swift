//
//  CacheManager.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import Foundation

import Foundation

class CacheManager {
    private let userDefaults = UserDefaults.standard
    private let menuCacheKey = "cachedMenuData"
    private let categoriesCacheKey = "cachedCategories"
    
    func save(menuData: MenuResponse) {
        if let encoded = try? JSONEncoder().encode(menuData) {
            userDefaults.set(encoded, forKey: menuCacheKey)
        }
    }
    
    func loadMenu() -> MenuResponse? {
        guard let data = userDefaults.data(forKey: menuCacheKey) else { return nil }
        return try? JSONDecoder().decode(MenuResponse.self, from: data)
    }
    
    func save(categories: [String: [Product]]) {
        if let encoded = try? JSONEncoder().encode(categories) {
            userDefaults.set(encoded, forKey: categoriesCacheKey)
        }
    }
    
    func loadCategories() -> [String: [Product]]? {
        guard let data = userDefaults.data(forKey: categoriesCacheKey) else { return nil }
        return try? JSONDecoder().decode([String: [Product]].self, from: data)
    }
}
