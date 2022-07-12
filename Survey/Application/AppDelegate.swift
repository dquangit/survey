//
//  AppDelegate.swift
//  Survey
//
//  Created by Quang Pham on 09/07/2022.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    static let assembler = Assembler([AppAssembly(), ServiceAssembly()])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LibsManager.setupLibs()
        launchStartPage()
        return true
    }
    
    private func launchStartPage() {
        window = UIWindow()
        let splashVC = AppDelegate.assembler.resolver.resolve(SplashViewController.self)!
        let nav = UINavigationController(rootViewController: splashVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

