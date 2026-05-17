//
//  AppDelegate.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        MobileAds.shared.start()
        
        return true
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 4/255, green: 88/255, blue: 228/255, alpha: 1)
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir-Heavy", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        ]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        let proxy = UINavigationBar.appearance()
        proxy.standardAppearance = appearance
        proxy.scrollEdgeAppearance = appearance
        proxy.compactAppearance = appearance
        proxy.tintColor = .white
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

