//
//  CustomBackgroundView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class CustomBackgroundView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setup()
    }
    
    func setup() {
        let margin:CGFloat = 15
        //背景色ラベル
        let backColorLabel = UILabel(frame:CGRect(x:margin,y:margin,width:100,height:15))
        backColorLabel.text = "背景色"
        backColorLabel.textColor = UIColor.darkText
        backColorLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.addSubview(backColorLabel)
        
        //コレクションビューを配置
        let backColorList = BackgroundColorListView(frame:CGRect(x:0,y:backColorLabel.frame.maxY,width:self.frame.width,height:80))
        self.addSubview(backColorList)
        
        //壁紙ラベル
        let backImageLabel = UILabel(frame:CGRect(x:margin,y:backColorList.frame.maxY,width:100,height:20))
        backImageLabel.text = "壁紙"
        backImageLabel.textColor = UIColor.darkText
        backImageLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.addSubview(backImageLabel)
        
        //コレクションビューを配置
        let backImageList = BackgroundImageView(frame:CGRect(x:0,y:backImageLabel.frame.maxY,width:self.frame.width,height:80))
        self.addSubview(backImageList)
    }
    
    
}
