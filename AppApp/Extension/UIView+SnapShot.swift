//
//  UIView+SnapShot.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/07.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let png = UIImagePNGRepresentation(image)!
        let pngImage = UIImage(data: png)!
        return pngImage
    }
}
