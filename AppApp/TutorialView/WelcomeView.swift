//
//  WelcomeView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class WelcomeView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.allLabel()
        setup()
    }
    
    func setup(){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let margin:CGFloat = 30.0
        //画像を置く
        let logoView = UIImageView(frame:CGRect(x:margin,y:margin,width:250,height:70))
        let titlePath = Bundle.main.path(forResource: "appapp_logo1", ofType: "png")
        logoView.image = UIImage(contentsOfFile:titlePath!)?.withRenderingMode(.alwaysTemplate)
        logoView.tintColor = UIColor.white
        logoView.contentMode = .scaleAspectFit
        self.addSubview(logoView)
        
        //ラベルを置く
        let explain = UILabel(frame:CGRect(x:logoView.frame.minX + margin,y:logoView.frame.maxY,width:width -  (margin * 4),height:150))
        explain.font = UIFont.boldSystemFont(ofSize: 20 + VersionManager.excess)
        explain.textColor = UIColor.white
        explain.numberOfLines = 0
        explain.text = "はじめまして。\nAppAppは、アイコンデザインを収集・閲覧するためのアプリです。"
        self.addSubview(explain)
    }

}
