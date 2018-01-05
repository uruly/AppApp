//
//  UploadView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class UploadView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setup()
    }
    
    func setup() {
        let margin:CGFloat = 15.0
        //ボタンを配置
        let uploadBtnWidth:CGFloat = self.frame.width - margin * 2
        let uploadBtn = UIButton(frame: CGRect(x:margin,y:margin,width:uploadBtnWidth,height:50))
        uploadBtn.setTitle("データを追加する", for: .normal)
        uploadBtn.setTitleColor(UIColor.white, for: .normal)
        uploadBtn.addTarget(self, action: #selector(self.uploadBtnTapped(sender:)), for: .touchUpInside)
        uploadBtn.addTarget(self, action: #selector(self.uploadBtnPressed(sender:)), for:.touchDown )
        uploadBtn.addTarget(self, action: #selector(self.uploadBtnReleased(sender:)), for: .touchDragExit)
        uploadBtn.backgroundColor = UIColor.mainBlue()
        self.addSubview(uploadBtn)
        uploadBtn.layer.cornerRadius = 10.0
        //影をつける
        uploadBtn.layer.masksToBounds = false
        uploadBtn.layer.shadowColor = UIColor.darkGray.cgColor
        uploadBtn.layer.shadowOffset = CGSize(width:1,height:1)
        uploadBtn.layer.shadowRadius = 4
        uploadBtn.layer.shadowOpacity = 0.5
    }
    
    @objc func uploadBtnTapped(sender:UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX:0.95,y:0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                sender.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc func uploadBtnPressed(sender:UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc func uploadBtnReleased(sender:UIButton){
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform.identity
        }
    }
}
