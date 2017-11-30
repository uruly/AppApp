//
//  UIColor+AppColor.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

extension UIColor {
    
    //デフォルトのAllLabelの色
    class func allLabel() -> UIColor {
        return UIColor(red: 10 / 255, green: 195 / 255, blue: 255 / 255, alpha: 1.0)
    }
    
    //セレクションバーの裏側の色 白花色 
    class func backgroundGray() -> UIColor {
        return UIColor(red: 232 / 255, green: 236 / 255, blue: 239 / 255, alpha: 1.0)
    }
    
    //＋ボタンの色 鈍色
    class func plusBackground() -> UIColor {
        return UIColor(red: 114 / 255, green: 113 / 255, blue: 113 / 255, alpha: 1.0)
    }
    
    //チェックボタンの色　未定
    class func checkBtn() -> UIColor {
        return UIColor.blue
    }
    
    class func blackMask() -> UIColor {
        return UIColor(red: 1 / 255, green: 1 / 255, blue: 1 / 255, alpha: 1)
    }
    
    class func placeholder() -> UIColor {
        return UIColor(red: 199 / 255, green: 199 / 255, blue: 205 / 255, alpha: 1)
    }
    
    class func appStoreBlue() -> UIColor {
        return UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
    }
    
    //花葉
    class func customColorView() -> UIColor {
        return UIColor(red: 247 / 255, green: 194 / 255, blue: 66 / 255, alpha: 1)
    }
}
