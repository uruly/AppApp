//
//  EditImageView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

//ドラッグ & ズームイン・ズームアウト　ができる
import UIKit

class EditImageView: UIImageView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 10.0
        
        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:1,height:1)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBega")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("moved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("end")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancel")
    }

}
