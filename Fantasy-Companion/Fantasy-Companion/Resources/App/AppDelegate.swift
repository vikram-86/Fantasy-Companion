//
//  AppDelegate.swift
//  Fantasy-Companion
//
//  Created by Vikram on 31/08/2019.
//  Copyright © 2019 Vikram. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let webService = WebService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        webService.request(DatabaseEndpoint.getBootstrap) { (result: Result<Int, NetworkStackError>) in
            
        }
        return true
    }
}

