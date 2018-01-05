//
//  UIView+FindView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

extension UIResponder {
    
    func findViewController<T: UIViewController>() -> T? {
        var responder = self.next
        while responder != nil {
            if let viewController = responder as? T {
                return viewController
            }
            responder = responder!.next
        }
        return nil
    }
    
}

