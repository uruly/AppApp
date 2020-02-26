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
import GoogleAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // GoogleAnalyticsの設定
        if let gai = GAI.sharedInstance() {
            gai.trackUncaughtExceptions = true

            if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
                if let propertyList = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                    let trackingID = propertyList["TRACKING_ID"] as! String
                    gai.tracker(withTrackingId: trackingID)
                }
            }
        }

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        BasePageViewController.isUnwind = true
        self.window?.rootViewController?.viewWillAppear(false)
    }

}
