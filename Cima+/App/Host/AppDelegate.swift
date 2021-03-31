//
//  AppDelegate.swift
//  Cima+
//
//  Created by Kerolles Roshdi on 3/29/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Stored properties
    
    private lazy var mainWindow = UIWindow()
    private let router = AppCoordinator().strongRouter

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        router.setRoot(for: mainWindow)
        return true
    }

}

