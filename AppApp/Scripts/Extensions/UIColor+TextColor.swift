//
//  UIColor+TextColor.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/28.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

extension UIColor {

    static func textColor(_ color: UIColor) -> UIColor {
        let grayscale = color.grayscale()
        return grayscale < 0.97 ? .white : .darkGray
    }

    func grayscale() -> CGFloat {
        var grayscale: CGFloat = 0
        var alpha: CGFloat = 0
        getWhite(&grayscale, alpha: &alpha)
        return grayscale
    }
}
