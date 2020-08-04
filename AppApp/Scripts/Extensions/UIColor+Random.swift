//
//  UIColor+Random.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

extension UIColor {

    static func getRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(254)) / 255
        let green = CGFloat(arc4random_uniform(254)) / 255
        let blue = CGFloat(arc4random_uniform(254)) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
