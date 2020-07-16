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

    let rootViewController = UINavigationController(rootViewController: ViewController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        return true
    }

}

