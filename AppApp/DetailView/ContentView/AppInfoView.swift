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
    var detailVC:DetailViewController!
    //var widthLayout:CGFloat!
    var canSetSubview = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("ここよばれ")
        //setSubviews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        print("kokoyo")
    }
    
    func setSubviews(){
        if canSetSubview == false {
            return
        }
        let margin:CGFloat = 15.0
        let width = self.frame.width
        let height = self.frame.height
        
        //イメージビューを配置
        imageView = UIImageView(frame:CGRect(x:margin,y:margin,width:width / 3,height:width / 3))
        imageView.image = UIImage(data:imageData)
        self.addSubview(imageView)
        
        //アプリ名を配置
        appNameLabel = UILabel(frame: CGRect(x:imageView.frame.maxX + margin,y:margin + 5,width:width - imageView.frame.width - (margin * 2),height:30))
        appNameLabel.text = appName
        appNameLabel.numberOfLines = 0
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        appNameLabel.sizeToFit()
        self.addSubview(appNameLabel)
        
        //ボタンを配置
        let showStoreBtn = UIButton()
        let btnWidth:CGFloat = 100.0
        //width - imageView.frame.width - (margin * 2)
        showStoreBtn.frame = CGRect(x:imageView.frame.maxX + margin,y:imageView.frame.maxY - 35,width:btnWidth,height:35)
        showStoreBtn.backgroundColor = UIColor.appStoreBlue()
        showStoreBtn.addTarget(detailVC, action: #selector(detailVC.showProductPage), for: .touchUpInside)
        showStoreBtn.setTitle("AppStore", for: .normal)
        showStoreBtn.setTitleColor(UIColor.white, for: .normal)
        showStoreBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.addSubview(showStoreBtn)
        
        //Webで見るボタン
        let webSearchBtn = UIButton()
        webSearchBtn.frame = CGRect(x:width - 50 + 10,y:imageView.frame.maxY - 35,width:50,height:35)
        webSearchBtn.backgroundColor = UIColor.appStoreBlue()
        webSearchBtn.addTarget(self, action: #selector(self.showWebPage), for: .touchUpInside)
        webSearchBtn.setTitle("Web", for: .normal)
        webSearchBtn.setTitleColor(UIColor.white, for: .normal)
        webSearchBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.addSubview(webSearchBtn)
        
        if appNameLabel.frame.maxY > showStoreBtn.frame.minY {
            print("被っているよ")
            appNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            appNameLabel.sizeThatFits(CGSize(width:appNameLabel.frame.width,height:showStoreBtn.frame.minY - appNameLabel.frame.minY))
            showStoreBtn.frame = CGRect(x:imageView.frame.maxX + margin,y:appNameLabel.frame.maxY,width:btnWidth,height:35)
            webSearchBtn.frame = CGRect(x:width - 50 + 10,y:appNameLabel.frame.maxY,width:50,height:35)
        }
        
        detailVC.contentView.topInfoFrame = CGSize(width:UIScreen.main.bounds.width,height:imageView.frame.maxY + margin)
        canSetSubview = false
    }
    
    @objc func showWebPage(){
        detailVC.segueToWebView(detailVC.appData.app.name)
    }

}

