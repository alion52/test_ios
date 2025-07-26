//
//  SceneDelegate.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 23.07.25.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.frame = UIScreen.main.bounds
        
        setupAuthController()
        
        window?.makeKeyAndVisible()
    }
    
    private func setupAuthController() {
        let authVC = AuthViewController()
        let navController = UINavigationController(rootViewController: authVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        navController.navigationBar.tintColor = .systemRed
        
        authVC.onAuthSuccess = { [weak self] in
            self?.switchToMainTabBar()
        }
        
        window?.rootViewController = navController
    }
    
    private func switchToMainTabBar() {
        let tabBarController = MainTabBarController()
        
        UIView.transition(with: window!,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
                            self.window?.rootViewController = tabBarController
                         },
                         completion: nil)
    }
}
