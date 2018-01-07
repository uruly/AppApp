//
//  CustomBackgroundView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class CustomBackgroundView: UIView {
    
    var backColorList:BackgroundColorListView!

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
        
        //履歴を削除ボタン
        let resetBackColor = UIButton()
        resetBackColor.frame = CGRect(x:self.frame.width - 100,y:margin,width:100,height:15)
        resetBackColor.setTitle("履歴を削除", for: .normal)
        resetBackColor.setTitleColor(UIColor.gray, for: .normal)
        resetBackColor.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        resetBackColor.tag = 1
        resetBackColor.addTarget(self, action: #selector(self.resetBtnTapped(sender:)), for: .touchUpInside)
        self.addSubview(resetBackColor)
        
        //コレクションビューを配置
        backColorList = BackgroundColorListView(frame:CGRect(x:0,y:backColorLabel.frame.maxY,width:self.frame.width,height:80))
        self.addSubview(backColorList)
        
        //壁紙ラベル
        let backImageLabel = UILabel(frame:CGRect(x:margin,y:backColorList.frame.maxY,width:100,height:20))
        backImageLabel.text = "壁紙"
        backImageLabel.textColor = UIColor.darkText
        backImageLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.addSubview(backImageLabel)
        
        //履歴を削除ボタン
        let resetBackImage = UIButton()
        resetBackImage.frame = CGRect(x:self.frame.width - 100,y:backColorList.frame.maxY + 5,width:100,height:15)
        resetBackImage.setTitle("履歴を削除", for: .normal)
        resetBackImage.setTitleColor(UIColor.gray, for: .normal)
        resetBackImage.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        resetBackImage.tag = 2
        resetBackImage.addTarget(self, action: #selector(self.resetBtnTapped(sender:)), for: .touchUpInside)
        self.addSubview(resetBackImage)
        
        //コレクションビューを配置
        let backImageList = BackgroundImageView(frame:CGRect(x:0,y:backImageLabel.frame.maxY,width:self.frame.width,height:80))
        self.addSubview(backImageList)
    }
    
    @objc func resetBtnTapped(sender:UIButton){
        if sender.tag == 1 { //背景色を消す
            
        }else {             //壁紙を消す
            
        }
    }
    
}
