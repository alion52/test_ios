//
//  DataManager.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import Foundation
import SystemConfiguration

class DataManager {
    private let apiClient = APIClient()
    private let cache = CacheManager()
    private let serialQueue = DispatchQueue(label: "com.foodapp.datamanager.queue")
    
    func fetchMenu(completion: @escaping (Result<MenuResponse, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            loadFromNetwork(completion: completion)
        } else {
            loadFromCache(completion: completion)
        }
    }
    
    private func loadFromNetwork(completion: @escaping (Result<MenuResponse, Error>) -> Void) {
        apiClient.fetchFullMenu { [weak self] result in
            self?.serialQueue.async {
                switch result {
                case .success(let menuData):
                    self?.cache.save(menuData: menuData)
                    DispatchQueue.main.async {
                        completion(.success(menuData))
                    }
                case .failure(let error):
                    self?.handleFallback(error: error, completion: completion)
                }
            }
        }
    }
    
    private func loadFromCache(completion: @escaping (Result<MenuResponse, Error>) -> Void) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            if let cached = self.cache.loadMenu() {
                DispatchQueue.main.async {
                    completion(.success(cached))
                }
            } else {
                let error = NSError(
                    domain: "FoodDeliveryApp",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Нет подключения к интернету и кэшированных данных"]
                )
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleFallback(error: Error, completion: @escaping (Result<MenuResponse, Error>) -> Void) {
        if let cached = cache.loadMenu() {
            DispatchQueue.main.async {
                completion(.success(cached))
            }
        } else {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}

class APIClient {
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://api.foodapp.com/v1")!
    
    func fetchFullMenu(completion: @escaping (Result<MenuResponse, Error>) -> Void) {
        let request = URLRequest(
            url: baseURL.appendingPathComponent("menu"),
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 15
        )
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(
                    domain: "APIClient",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Нет данных в ответе"]
                )
                completion(.failure(error))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MenuResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
