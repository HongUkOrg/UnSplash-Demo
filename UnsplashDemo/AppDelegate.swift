//
//  AppDelegate.swift
//  UnsplashDemo
//
//  Created by bleo on 2020/10/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame: UIScreen.main.bounds)
        TempNavigator.window = window
        TempNavigator.shared.navigate(.photo(.main))
        return true
    }
}

