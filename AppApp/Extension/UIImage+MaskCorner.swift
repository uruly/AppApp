//
//  UIImage+MaskCorner.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/07.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

extension UIImage {
    func maskCorner(radius r: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0.0)
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        UIBezierPath(roundedRect: rect, cornerRadius: r).addClip()
        draw(in: rect)
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return clippedImage
    }
}
