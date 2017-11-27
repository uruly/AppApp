//
//  AppInfoView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class AppInfoView: UIView {

    var imageView:UIImageView!
    var appNameLabel:UILabel!
    
    var imageData:Data!
    var appName:String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //setSubviews()
    }
    
    func setSubviews(){
        let margin:CGFloat = 15.0
        let width = self.frame.width
        let height = self.frame.height
        
        //イメージビューを配置
        imageView = UIImageView(frame:CGRect(x:margin,y:margin,width:width / 3,height:width / 3))
        imageView.image = UIImage(data:imageData)
        self.addSubview(imageView)
        
        //アプリ名を配置
        appNameLabel = UILabel(frame: CGRect(x:imageView.frame.maxX + margin,y:margin,width:width - imageView.frame.width - (margin * 2),height:200))
        appNameLabel.text = appName
        appNameLabel.numberOfLines = 0
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        appNameLabel.sizeToFit()
        self.addSubview(appNameLabel)
        
        
    }

}

