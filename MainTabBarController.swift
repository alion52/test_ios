//
//  MainTabBarController.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 25.07.25.
//
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
      
        let menuVC = MainViewController()
        let contactsVC = ContactsViewController()
        let profileVC = ProfileViewController()
        let cartVC = CartViewController()
        
        
        menuVC.tabBarItem = UITabBarItem(
            title: "Меню",
            image: UIImage(systemName: "menucard"),
            tag: 0
        )
        
        contactsVC.tabBarItem = UITabBarItem(
            title: "Контакты",
            image: UIImage(systemName: "location"),
            tag: 1
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            tag: 2
        )
        
        cartVC.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(systemName: "cart"),
            tag: 3
        )
        
        
        viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: contactsVC),
            UINavigationController(rootViewController: profileVC),
            UINavigationController(rootViewController: cartVC)
        ]
    }
    
    private func setupAppearance() {
      
        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .systemGray
        
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
