//
//  Extensions.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.
//
// Extensions.swift
import UIKit

extension Array where Element == Int {
    func unique() -> [Element] {
        return Array(Set(self)).sorted()
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-10, 10, -8, 8, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}

