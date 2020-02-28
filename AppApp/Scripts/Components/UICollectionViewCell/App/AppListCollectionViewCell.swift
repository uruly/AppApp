//
//  AppListCollectionViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class AppListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var checkImageView: UIImageView!

    var imageMaskView: UIView!
    //var checkView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        checkImageView.isHidden = true

        //影をつけるかどうか
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
    }

}
