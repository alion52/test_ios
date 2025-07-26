//
//  AppDelegate.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 23.07.25.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - App Lifecycle
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureAppearance()
        setupInitialConfiguration()
        
        return true
    }

    // MARK: - UISceneSession Lifecycle (если используете SceneDelegate)
    func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    // MARK: - Configuration Methods
    private func configureAppearance() {
        UINavigationBar.appearance().tintColor = .systemRed
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        UITabBar.appearance().tintColor = .systemRed
        UITabBar.appearance().unselectedItemTintColor = .systemGray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setupInitialConfiguration() {
        // Здесь можно добавить:
        // - Проверку первой загрузки приложения
        // - Настройку Firebase/Analytics
        // - Проверку миграции данных
    }
}
