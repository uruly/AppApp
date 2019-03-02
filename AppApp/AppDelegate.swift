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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        
        
        let receiptValidator = ReceiptValidator()
        let validationResult = receiptValidator.validateReceipt()
        switch validationResult {
        case .success(let receipt):
            let appVersion = receipt.appVersion ?? ""
            let date = receipt.expirationDate
            let origAppVersion = receipt.originalAppVersion ?? ""
            GATrackingManager.sendEventTracking(category: "APP VERSION:\(appVersion)", action: "DATE:\(String(describing: date))", label: "ORIGINAL VERSION:\(origAppVersion)")
        case .error(let error):
            // Handle receipt validation failure. Possibilities might be...
            // use StoreKit to request a new receipt
            // enter a "grace period"
            // disable a feature of your app
            // etc...
            GATrackingManager.sendEventTracking(category: "レシートないよ", action: "\(error)", label: "")
            print(error)
        }
        
        //window?.rootViewController = DetailViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //print("willResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        BasePageViewController.isUnwind = true
        self.window?.rootViewController?.viewWillAppear(false)
        //print("willenterForground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //print("didbecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

