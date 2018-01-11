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
import GoogleAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        print(Bundle.main.appStoreReceiptURL)
//        if let receiptUrl: URL = Bundle.main.appStoreReceiptURL {
//            print("れしーとurlaruyo")
//            if let receiptData: NSData = NSData(contentsOf: receiptUrl){
//                print("レシートデータあるよ")
//                let receiptBase64Str: String = receiptData.base64EncodedString(options:[])
//                let requestContents: NSDictionary = ["receipt-data": receiptBase64Str] as NSDictionary
//                print("ここ")
//                do {
//                    let requestData: NSData = try JSONSerialization.data(withJSONObject: requestContents, options: .prettyPrinted) as NSData
//                    let sandboxUrl: NSURL = NSURL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
//                    let request: NSMutableURLRequest = NSMutableURLRequest(url: sandboxUrl as URL)
//
//                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"content-type")
//                    request.timeoutInterval = 5.0
//                    request.httpMethod = "POST"
//                    request.httpBody = requestData as Data
//
//
//                    let configuration = URLSessionConfiguration.default
//                    let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
//
//                    let task = session.dataTask(with: request as URLRequest, completionHandler: {
//                        (data, response, error) -> Void in
//                        do {
//
//                            let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments ) as! NSArray
//                            print(json)
//
//                        } catch {
//                            print(error)
//                            //エラー処理
//                        }
//
//                    })
//
//                }catch {
//                    print(error)
//                }
//            }else {
//                print("取得できない")
//            }
//        }
//
        let receiptValidator = ReceiptValidator()
        let validationResult = receiptValidator.validateReceipt()
        switch validationResult {
        case .success(let receipt):
            // Work with parsed receipt data. Possibilities might be...
            // enable a feature of your app
            // remove ads
        // etc...
            print(receipt)
        case .error(let error):
            // Handle receipt validation failure. Possibilities might be...
            // use StoreKit to request a new receipt
            // enter a "grace period"
            // disable a feature of your app
            // etc...
            print(error)
        }
        
        
        //window?.rootViewController = DetailViewController()
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

