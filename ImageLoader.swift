//
//  ImageLoader.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
import UIKit

class ImageLoader {
    private static let cache = NSCache<NSString, UIImage>()
    
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            cache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
