//
//  BackgroundImageCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class BackgroundImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 10.0

        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
    }

}
