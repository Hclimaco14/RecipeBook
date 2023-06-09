//
//  AppDelegate.swift
//  RecipeBook
//
//  Created by Hector Climaco on 11/04/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let vc = RecipeHomeViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }


}

