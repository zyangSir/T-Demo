//
//  AppDelegate.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initAmplifySDK()
        
        if #available(iOS 13.0, *) {
            
        }else{
            //For Facebook SSO
            ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //For Facebook SSO
        ApplicationDelegate.shared.application(app, open: url, sourceApplication:  options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation:  options[UIApplication.OpenURLOptionsKey.annotation])
    }
        
    
    // MARK: AWS SDK
    func initAmplifySDK() {
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
           try Amplify.add(plugin:dataStorePlugin)
           try Amplify.configure()
           print("Initialized Amplify successfully.");
           //Amplify.Logging.logLevel = .info
        } catch {
           print("Could not initialize Amplify: \(error)")
        }
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

