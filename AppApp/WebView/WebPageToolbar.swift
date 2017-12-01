//
//  WebPageToolbar.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//


import UIKit

class WebPageToolbar: UIToolbar {
    
    func didChangeLayout(toolbarMinY:CGFloat,height:CGFloat,bottomInset:CGFloat){
        //let toolbarMinY = self.view.frame.height - toolBarHeight - self.view.safeAreaInsets.bottom
        self.frame = CGRect(x:0,y:toolbarMinY,width:self.frame.width,height:height)
        //self.frame.size.height += 32
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let isiPhoneX = UIScreen.main.bounds.size == CGSize(width: 375, height: 812)
        let bottomInset:CGFloat = 34
        if #available(iOS 11.0, *) ,isiPhoneX{
            for subview in self.subviews {
                let stringFromClass = NSStringFromClass(subview.classForCoder)
                //print(stringFromClass)
                if stringFromClass.contains("BarBackground") {
                    subview.frame = self.bounds
                    //print(subview.frame)
                    subview.backgroundColor = UIColor.green
                    //subview.frame.size.height = self.bounds.height
                } else if stringFromClass.contains("ContentView") {
                    subview.frame.origin.y = 0
                    subview.frame.size.height = self.bounds.height - bottomInset
                    for contentSubview in subview.subviews {
                        for barItem in contentSubview.subviews{
                            for constraint in barItem.constraints {
                                if let id = constraint.identifier,id.contains("height"){
                                    //print(id)
                                    constraint.priority = .defaultLow
                                }
                            }
                            //barItem.constraints.removeAll()
                            let bottom = barItem.bottomAnchor.constraint(equalTo: contentSubview.bottomAnchor, constant: -bottomInset)
                            bottom.priority = .required
                            bottom.isActive = true
                            //let heightConst = barItem.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
                            let heightConst = barItem.heightAnchor.constraint(lessThanOrEqualTo: contentSubview.heightAnchor, multiplier: 0.9)
                            //let heightConst = barItem.heightAnchor.constraint(lessThanOrEqualToConstant: contentSubview.frame.height)
                            //barItem.heightAnchor.constraint(greaterThanOrEqualToConstant: <#T##CGFloat#>)
                            heightConst.priority = UILayoutPriority.required
                            heightConst.isActive = true
                        }
                    }
                }
            }
        }
    }
}

