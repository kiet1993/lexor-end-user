//
//  AppDelegate.swift
//  Lexor_iOS_EndUser
//
//  Created by Le Kim Tuan on 06/05/2021.
//

import UIKit
import GoogleSignIn
import GoogleMaps
import FBSDKCoreKit
import IQKeyboardManagerSwift
import SVProgressHUD

typealias HUD = SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    static let shared = UIApplication.shared.delegate as? AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(Config.googleAPIKey)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        window.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        // For disable user interaction when show hud
        HUD.setDefaultMaskType(.clear)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance.handle(url)
    }
}

