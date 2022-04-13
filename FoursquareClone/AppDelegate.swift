//
//  AppDelegate.swift
//  FoursquareClone
//
//  Created by Ali Osman DURMAZ on 2.04.2022.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        // Parse entegrasyon işlemi !!!!!!!
        let configuration = ParseClientConfiguration { ParseMutableClientConfiguration in
            ParseMutableClientConfiguration.applicationId = "JIdI70NxYK8Ujgz8wIRcUddXu3L00daGcDlglVsO"
            ParseMutableClientConfiguration.clientKey = "d4An4lszWZGeNTUP3VAPx90gUTXXaDiwRKRVnOhn"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
            
        }
        
        Parse.initialize(with: configuration)
        return true
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

