//
//  AppDelegate.swift
//  Todoey
//
//  Created by Blake Patenaude on 2019-06-01.
//  Copyright © 2019 Blake Patenaude. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        } catch {
            print("Error init new realm, \(error)")
        }
        
        return true
    }
}
