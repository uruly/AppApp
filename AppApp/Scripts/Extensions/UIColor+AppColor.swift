//
//  UIColor+AppColor.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

extension UIColor {

    // ＋ボタンの色 鈍色
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

    class func howto() -> UIColor {
        return UIColor(red: 88 / 255, green: 191 / 255, blue: 193 / 255, alpha: 1)
    }

    class func start() -> UIColor {
        return UIColor(red: 47 / 255, green: 138 / 255, blue: 197 / 255, alpha: 1)
    }

    class func help() -> UIColor {
        return UIColor(red: 248 / 255, green: 181 / 255, blue: 0 / 255, alpha: 1)
    }
}
