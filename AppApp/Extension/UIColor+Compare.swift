//
//  UIColor+Compare.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/09.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

extension UIColor {
    func compare(_ rhs:UIColor) -> Bool {
        var red = false
        var green = false
        var blue = false
        var alpha = false
        let components = self.cgColor.components!
        let rhsComponents = rhs.cgColor.components!
        print("components:\(components)")
        print("rhsComponents:\(rhsComponents)")
        if floor(components[0]*100000) == floor(rhsComponents[0]*100000){
            print("red一緒")
            red = true
        }
        if floor(components[1]*100000) == floor(rhsComponents[1]*100000){
            print("green一緒")
            green = true
        }
        if floor(components[2]*100000) == floor(rhsComponents[2]*100000){
            print("blue一緒")
            blue = true
        }
        if components[3] == rhsComponents[3]{
            print("alpha一緒")
            alpha = true
        }
        
        if red && green && blue && alpha {
            return true
        }else {
            return false
        }
    }
    
}

func ==(lhs: UIColor, rhs: UIColor) -> Bool {
    var lhsRed: CGFloat = 0.0
    var lhsGreen: CGFloat = 0.0
    var lhsBlue: CGFloat = 0.0
    var lhsAlpha: CGFloat = 0.0
    lhs.getRed(&lhsRed, green: &lhsGreen, blue: &lhsBlue, alpha: &lhsAlpha)
    
    var rhsRed: CGFloat = 0.0
    var rhsGreen: CGFloat = 0.0
    var rhsBlue: CGFloat = 0.0
    var rhsAlpha: CGFloat = 0.0
    rhs.getRed(&rhsRed, green: &rhsGreen, blue: &rhsBlue, alpha: &rhsAlpha)
    
    return lhsRed == rhsRed && lhsGreen == rhsGreen && lhsBlue == rhsBlue && lhsAlpha == rhsAlpha
}
