//
//  VersionManager.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

//アプリの番号
let APPLE_ID = "1319908151" //自分のアプリの番号
let RESOLUTION:String = "@" + String(Int(UIScreen.main.scale)) + "x"


struct VersionManager {
    
    static var alertController:UIAlertController?
    
    init(){
        VersionManager.checkVersion()
    }
    
    /****************** Version Check *********************/
    static func checkVersion(){
        let url = "https://itunes.apple.com/jp/lookup?id=\(APPLE_ID)"
        let req = URLRequest(url: URL(string: url)!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60.0)
        NSURLConnection.sendAsynchronousRequest(req,queue: OperationQueue.main,completionHandler:{(data,response,error) in
            do{
                if response != nil{
                    let dic = try JSONSerialization.jsonObject(with: response!, options: .mutableContainers) as! NSDictionary
                    let resultsArray = dic.object(forKey: "results") as! NSArray
                    if resultsArray.count > 0{
                        let results = resultsArray[0] as! NSDictionary
                        let storeVersion = results.object(forKey: "version") as! String
                        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                        print("latest version : \(storeVersion)")
                        if storeVersion.compare(currentVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending {
                            print("store version is newer!")
                            self.versionAlert()
                        } else if storeVersion.compare(currentVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame{
                            print("store version is equal")
                        } else {
                            print("store version is older")
                        }
                    }
                }
            }catch{
                print(error)
            }
            
        })
    }
    static func versionAlert(){
        alertController = UIAlertController(title: "新しいバージョンがあります。", message: "", preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "アップデートする", style: .destructive) {
            action in NSLog("はいボタンが押されました")
            let urlString = "itms-apps://itunes.apple.com/app/id\(APPLE_ID)"
            let url = NSURL(string: urlString)
            UIApplication.shared.openURL(url! as URL)
        }
        let cancelAction = UIAlertAction(title: "あとで", style: .cancel) {
            action in NSLog("いいえボタンが押されました")
        }
        
        alertController!.addAction(otherAction)
        alertController!.addAction(cancelAction)
    }
    
//    static func tabSizeHeight() ->  CGFloat{
//        let screenWidth = UIScreen.main.bounds.width
//        print(screenWidth) //375   //320  //414
//        if screenWidth <= 320.0{
//            return 48
//        }else if screenWidth <= 375.0{
//            return 58
//        }else if screenWidth > 376.0{
//            return 63
//        }else {
//            return 58
//        }
//    }
//
//    static func naviSizeHeight() -> CGFloat {
//        let screenWidth = UIScreen.main.bounds.width
//        print(screenWidth) //375   //320  //414
//        if screenWidth <= 320.0{
//            return 52
//        }else if screenWidth <= 375.0{
//            return 60
//        }else if screenWidth > 376.0{
//            return 67
//        }else {
//            return 60
//        }
//    }
    
    static var excess:CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth <= 320.0{
            return -2
        }else if screenWidth <= 375.0{
            return 0
        }else if screenWidth > 376.0{
            return 2
        }else {
            return 2
        }
    }
}

