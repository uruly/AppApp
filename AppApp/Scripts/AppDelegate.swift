//
//  AppDelegate.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = HomeViewController(nib: R.nib.homeViewController)
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let navigationController = window?.rootViewController, let viewController = navigationController.children.first else { return }
        viewController.viewWillAppear(true)
    }

}
