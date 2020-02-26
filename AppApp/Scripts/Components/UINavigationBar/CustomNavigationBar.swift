//
//  CustomNavigationBar.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()

        if #available(iOS 11.0, *) {
            for subview in self.subviews {
                let stringFromClass = NSStringFromClass(subview.classForCoder)
                if stringFromClass.contains("BarBackground") {
                    subview.frame = self.bounds
                } else if stringFromClass.contains("ContentView") {
                    subview.frame.origin.y = UIApplication.shared.statusBarFrame.height
                    subview.frame.size.height = self.bounds.height - UIApplication.shared.statusBarFrame.height
                }
            }
        }
    }

}
