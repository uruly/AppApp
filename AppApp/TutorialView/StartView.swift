//
//  StartView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class StartView: UIView {
    
    var tutorialVC:TutorialViewController! {
        didSet {
            startBtn.addTarget(tutorialVC, action: #selector(tutorialVC.closeTutorial), for: .touchUpInside)
        }
    }

    var startBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        self.backgroundColor = UIColor.start()
    }
    
    func setup(){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let margin:CGFloat = 15.0
        
        let header = UILabel(frame:CGRect(x:margin,y:0,width:300,height:100))
        header.font = UIFont.boldSystemFont(ofSize: 22)
        header.textColor = UIColor.white
        header.text = "はじめよう！"
        header.numberOfLines = 0
        self.addSubview(header)
        
        startBtn = UIButton(frame:CGRect(x:margin,y:width / 2,width:200,height:50))
        startBtn.center = CGPoint(x:width / 2,y:width * 2 / 3)
        startBtn.setTitle("スタート", for: .normal)
        startBtn.setTitleColor(UIColor.darkGray, for: .normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startBtn.backgroundColor = UIColor.white
        startBtn.layer.cornerRadius = 10
        //影をつける
        startBtn.layer.masksToBounds = false
        startBtn.layer.shadowColor = UIColor.darkGray.cgColor
        startBtn.layer.shadowOffset = CGSize(width:3,height:3)
        startBtn.layer.shadowRadius = 4
        startBtn.layer.shadowOpacity = 0.5
        
        self.addSubview(startBtn)
    }
}
