//
//  AppInfoView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class AppInfoView: UIView {

    var imageView: UIImageView!
    var appNameLabel: UILabel!

    var url: String!
    var imageData: Data!
    var appName: String!
    var detailVC: DetailViewController!
    //var widthLayout:CGFloat!
    var canSetSubview = true
    var isAppStore: Bool!
    //var showStoreBtn:UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("ここよばれ")
        //setSubviews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        //print("kokoyo")
    }

    func setSubviews() {
        guard canSetSubview else { return }
        let margin: CGFloat = 15.0
        let width = UIScreen.main.bounds.width
        //イメージビューを配置
        imageView = UIImageView(frame: CGRect(x: margin, y: margin, width: width / 3, height: width / 3))
        imageView.image = UIImage(data: imageData)
        self.addSubview(imageView)

        //アプリ名を配置
        appNameLabel = UILabel(frame: CGRect(x: imageView.frame.maxX + margin, y: margin, width: width - imageView.frame.maxX - (margin * 2), height: 30))
        appNameLabel.text = appName
        appNameLabel.numberOfLines = 0
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        appNameLabel.sizeToFit()
        self.addSubview(appNameLabel)

        //ボタンを配置
        let showStoreBtn = UIButton()
        let btnWidth: CGFloat = 100.0
        let btnHeight: CGFloat = 30.0
        showStoreBtn.frame = CGRect(x: imageView.frame.maxX + margin, y: imageView.frame.maxY - btnHeight, width: btnWidth, height: btnHeight)
        showStoreBtn.backgroundColor = R.color.appStoreBlueColor()
        showStoreBtn.addTarget(detailVC, action: #selector(detailVC.showProductPage), for: .touchUpInside)

        if isAppStore {
            showStoreBtn.setTitle("AppStore", for: .normal)
        } else if url != "" {
            showStoreBtn.setTitle("取得元を表示", for: .normal)
        } else {
            showStoreBtn.isHidden = true
        }
        showStoreBtn.setTitleColor(UIColor.white, for: .normal)
        showStoreBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        showStoreBtn.layer.cornerRadius = btnHeight / 2
        self.addSubview(showStoreBtn)

        let webSearchBtn = UIButton()
        webSearchBtn.frame = CGRect(x: width - 50 - margin, y: imageView.frame.maxY - btnHeight, width: 50, height: btnHeight)
        webSearchBtn.backgroundColor = R.color.appStoreBlueColor()
        webSearchBtn.addTarget(self, action: #selector(self.showWebPage), for: .touchUpInside)
        webSearchBtn.setTitle("Web", for: .normal)
        webSearchBtn.setTitleColor(UIColor.white, for: .normal)
        webSearchBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        webSearchBtn.layer.cornerRadius = btnHeight / 2
        self.addSubview(webSearchBtn)

        if appNameLabel.frame.maxY > showStoreBtn.frame.minY {
            appNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            appNameLabel.sizeThatFits(CGSize(width: appNameLabel.frame.width, height: showStoreBtn.frame.minY - appNameLabel.frame.minY))
            showStoreBtn.frame = CGRect(x: imageView.frame.maxX + margin, y: appNameLabel.frame.maxY, width: btnWidth, height: btnHeight)
            webSearchBtn.frame = CGRect(x: width - 50 + 10, y: appNameLabel.frame.maxY, width: 50, height: btnHeight)
        }

        detailVC.contentView.topInfoFrame = CGSize(width: UIScreen.main.bounds.width, height: imageView.frame.maxY + margin)
        canSetSubview = false
    }

    @objc func showWebPage() {
        detailVC.segueToWebView(detailVC.appData.app.name)
    }

}
