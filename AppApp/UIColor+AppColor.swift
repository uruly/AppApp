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
    
}
