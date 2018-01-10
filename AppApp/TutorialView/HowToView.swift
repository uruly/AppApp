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
    var headerTextArray = ["まずは、AppStoreから保存してみよう！","AppAppアイコンを選択","Appを保存","スクリーンショットや外部のアプリから保存しよう","写真からアップロードしよう","ラベルをつけて整理しよう"] //4

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.howto()
        //setup()
    }
    
    func setup(index:Int){
        setupAppStore(index: index)
        
    }
    
    func setupList(){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let margin:CGFloat = 15.0
        header = UILabel(frame:CGRect(x:margin,y:0,width:300,height:100))
        header.font = UIFont.boldSystemFont(ofSize: 22 + VersionManager.excess)
        header.textColor = UIColor.white
        header.text = "アイコンデザインをAppApp外から保存しよう！"
        header.numberOfLines = 0
        self.addSubview(header)
    }
    
    func setupAppStore(index:Int) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let margin:CGFloat = 15.0
        header = UILabel(frame:CGRect(x:margin,y:0,width:300,height:100))
        header.font = UIFont.boldSystemFont(ofSize: 22 + VersionManager.excess)
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
        if index == 0 {
            let rect = CGRect(x:screenShot.frame.maxX - 180,y:screenShot.frame.minY + screenShot.frame.width - 80,width:200,height:80)
            let balloonView = BalloonView(frame: rect,color:UIColor.allLabel())
            balloonView.isDown = false
            balloonView.label.text = "ここをタップ"
            balloonView.label.textColor = UIColor.white
            self.addSubview(balloonView)
            animation(balloonView)
        }else if index == 1 {
            let rect = CGRect(x:margin * 3,y:screenShot.frame.minY + screenShot.frame.width - 80,width:200,height:120)
            let balloonView = BalloonView(frame: rect,color:UIColor.allLabel())
            balloonView.isDown = true
            balloonView.label.text = "長押しで順番を入れ替え\nすると使いやすい！"
            balloonView.label.textColor = UIColor.white
            self.addSubview(balloonView)
            animation(balloonView)
        }else if index == 2 {
            let rect = CGRect(x:(width - 200) / 2,y:screenShot.frame.minY + screenShot.frame.width + margin,width:200,height:120)
            let balloonView = BalloonView(frame: rect,color:UIColor.allLabel())
            balloonView.isDown = false
            balloonView.label.text = "メモやラベルは後から変更可能！"
            balloonView.label.textColor = UIColor.white
            self.addSubview(balloonView)
            animation(balloonView)
        }else if index == 3 {
            let rect = CGRect(x:(width - 200) / 2,y:screenShot.frame.minY + screenShot.frame.width + margin,width:200,height:120)
            let balloonView = BalloonView(frame: rect,color:UIColor.allLabel())
            balloonView.isDown = false
            balloonView.label.text = "画像共有ができるアプリからはトリミングして保存！"
            balloonView.label.textColor = UIColor.white
            self.addSubview(balloonView)
            animation(balloonView)
        }else if index == 4 {
            let rect = CGRect(x:(width - 200) / 2,y:screenShot.frame.minY + screenShot.frame.width - 80,width:200,height:120)
            let balloonView = BalloonView(frame: rect,color:UIColor.allLabel())
            balloonView.isDown = true
            balloonView.label.text = "下部メニューから\nアップロード可能！"
            balloonView.label.textColor = UIColor.white
            self.addSubview(balloonView)
            animation(balloonView)
        }
    }
    
    func animation(_ view:BalloonView){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat,.autoreverse,.curveEaseIn], animations: {
            view.center.y += 5.0
        }, completion: nil)
    }

}
