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
    var backImageList:BackgroundImageView!

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
        
        //デフォルトに戻す
        let resetBackColor = UIButton()
        resetBackColor.frame = CGRect(x:self.frame.width - 130,y:margin,width:130,height:15)
        resetBackColor.setTitle("デフォルトに戻す", for: .normal)
        resetBackColor.setTitleColor(UIColor.gray, for: .normal)
        resetBackColor.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        resetBackColor.titleLabel?.textAlignment = .right
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
        //self.addSubview(resetBackImage)
        
        //コレクションビューを配置
        backImageList = BackgroundImageView(frame:CGRect(x:0,y:backImageLabel.frame.maxY,width:self.frame.width,height:80))
        self.addSubview(backImageList)
    }
    
    @objc func resetBtnTapped(sender:UIButton){
        if sender.tag == 1 { //背景色をデフォルトに戻す
            //ポップアップを表示
            BackgroundColorListView.isDefaultColor = true
            AppLabel.currentBackgroundColor = nil
            AppLabel.currentBackgroundImage = nil
            //更新
            if let basePageVC:BasePageViewController = findViewController() {
                confirmPopup(pageVC: basePageVC)
                if let baseVC:BaseViewController = basePageVC.viewControllers?.first as? BaseViewController {
                    if UserDefaults.standard.bool(forKey: "isList"){
                        baseVC.backgroundColor = baseVC.appLabel.color
                    }else {
                        baseVC.backgroundColor = UIColor.white
                    }
                    baseVC.backgroundImage = nil
                }
            }
            self.backColorList.reloadData()
            //壁紙の設定を戻す
            UserDefaults.standard.removeObject(forKey: "backgroundImage")
            self.backImageList.currentImage = nil
            self.backImageList.currentIndexPath = nil
            self.backImageList.reloadData()
        }else {             //壁紙を消す
            
        }
    }
    
    func confirmPopup(pageVC:BasePageViewController){
        //ポップアップを表示
        let alertController = UIAlertController(title: "背景色をデフォルトに戻しました", message: "", preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default) {
            action in
            NSLog("はいボタンが押されました")
        }
        
        alertController.addAction(otherAction)
        
        pageVC.present(alertController, animated: true, completion: nil)
    }
}
