//
//  AppDelegate.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var rootNavigationController: UINavigationController?
    var rootWindow: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        rootWindow = window
        
        let viewController = ViewController()
        let rootViewController = UINavigationController(rootViewController: viewController)
        rootNavigationController = rootViewController

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        return true
    }

}

