//
//  HowToView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class HowToView: UIView {
    
    var header:UILabel!
    var headerTextArray = ["まずは、AppStoreで\n気になるアプリを見つけよう！","AppAppアイコンを選択！","Appを保存してみよう！","保存したらAppAppで閲覧しよう！","",""]

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.allLabel()
        //setup()
    }
    
    func setup(index:Int){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let margin:CGFloat = 15.0
        header = UILabel(frame:CGRect(x:margin,y:0,width:300,height:100))
        header.font = UIFont.boldSystemFont(ofSize: 22)
        header.textColor = UIColor.white
        header.text = headerTextArray[index]
        header.numberOfLines = 0
        self.addSubview(header)
        
        let iphone = UIImageView(frame:CGRect(x:0,y:0,width:width,height:width * 2))
        let iphonePath = Bundle.main.path(forResource: "iphone", ofType: "png")
        iphone.image = UIImage(contentsOfFile:iphonePath!)?.withRenderingMode(.alwaysTemplate)
        iphone.contentMode = .scaleAspectFit
        iphone.tintColor = UIColor.darkGray
        self.addSubview(iphone)
        
        //スクリーンショットを乗せる
        let screenShot = UIImageView(frame:CGRect(x:0,y:0,width:width * 2 / 3 - margin,height:width * 2 / 3 * 2))
        screenShot.center = CGPoint(x:iphone.center.x,y:iphone.center.y)
        let ssPath = Bundle.main.path(forResource: "screenShot\(index)", ofType: "jpeg")
        screenShot.image = UIImage(contentsOfFile:ssPath!)
        screenShot.contentMode = .scaleAspectFit
        self.addSubview(screenShot)
        
        //吹き出しを設置
    }
    

}
