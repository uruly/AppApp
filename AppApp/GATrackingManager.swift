//
//  GATrackingManager.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/10.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import GoogleAnalytics

class GATrackingManager {
    
    //スクリーントラッキング
    class func sendScreenTracking(screenName: String) {
        if let tracker = GAI.sharedInstance().defaultTracker {
            tracker.set(kGAIScreenName, value: screenName)
            tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject: AnyObject])
            tracker.set(kGAIScreenName, value: nil)
        }
    }
    
    //イベントトラッキング
    class func sendEventTracking(category: String, action: String, label: String) {
        if let tracker = GAI.sharedInstance().defaultTracker {
            tracker.send(GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil).build() as [NSObject: AnyObject])
        }
    }
    
}
