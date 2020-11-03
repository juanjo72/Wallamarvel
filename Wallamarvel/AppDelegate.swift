//
//  AppDelegate.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        return window
    }()
    
    lazy var app: App = {
        App(window: window!)
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // early exit if running tests
        guard !application.isTesting else {
            window?.rootViewController = UIViewController()
            return true
        }
        app.appDidLaunch()
        
        return true
    }
}

fileprivate extension UIApplication {
     var isTesting: Bool {
        return NSClassFromString("XCTest") != nil
    }
}
