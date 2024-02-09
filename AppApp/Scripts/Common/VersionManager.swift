//
//  VersionManager.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

struct VersionManager {

    // var alertController:UIAlertController?

    init(viewController: UIViewController) {
        self.checkVersion(viewController)
    }

    /****************** Version Check *********************/
    func checkVersion(_ viewController: UIViewController) {
        let url = "https://itunes.apple.com/jp/lookup?id=\(String.appleID)"
        let req = URLRequest(url: URL(string: url)!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 60.0)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        //        NSURLConnection.sendAsynchronousRequest(req,queue: OperationQueue.main,completionHandler:{(data,response,error) in
        let task = session.dataTask(with: req, completionHandler: { (data, _, error) in
            do {
                if data != nil {
                    //                    let dic = try JSONSerialization.jsonObject(with: response!, options: .mutableContainers) as! NSDictionary
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    let resultsArray = dic.object(forKey: "results") as! NSArray
                    if resultsArray.count > 0 {
                        let results = resultsArray[0] as! NSDictionary
                        let storeVersion = results.object(forKey: "version") as! String
                        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                        print("latest version : \(storeVersion)")
                        if storeVersion.compare(currentVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending {
                            print("store version is newer!")
                            self.versionAlert(viewController)
                        } else if storeVersion.compare(currentVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame {
                            print("store version is equal")
                        } else {
                            print("store version is older")
                        }
                    }
                }
            } catch {
                print(error)
            }

        })
        task.resume()
    }

    func versionAlert(_ viewController: UIViewController) {
        let alertController = UIAlertController(title: "新しいバージョンがあります。", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "アップデートする", style: .destructive) { _ in
            let urlString = "itms-apps://itunes.apple.com/app/id\(String.appleID)"
            if let url = NSURL(string: urlString) {
                UIApplication.shared.open(url as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        })
        alertController.addAction(UIAlertAction(title: "あとで", style: .cancel))
        viewController.present(alertController, animated: true, completion: nil)

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

    static var excess: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth <= 320.0 {
            return -2 + VersionManager.excessiPad
        } else if screenWidth <= 375.0 {
            return 0 + VersionManager.excessiPad
        } else if screenWidth > 376.0 {
            return 2 + VersionManager.excessiPad
        } else {
            return 2 + VersionManager.excessiPad
        }
    }

    static var excessiPad: CGFloat {
        if UIDevice.current.model.range(of: "iPad") != nil {
            return -2
        } else {
            return 0
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
