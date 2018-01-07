//
//  BackgroundPlusCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/07.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class BackgroundPlusCell: UICollectionViewCell {
    
    var textLabel:UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = UILabel(frame:self.contentView.frame)
        textLabel.text = "＋"
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.plusBackground()
        self.contentView.addSubview(textLabel)
        
        self.contentView.layer.cornerRadius = 10.0
        
        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:1,height:1)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
    }
}
