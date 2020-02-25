//
//  UIImage+MaskCorner.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/07.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

extension UIImage {

    func maskCorner(radius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        draw(in: rect)
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return clippedImage
    }
}
