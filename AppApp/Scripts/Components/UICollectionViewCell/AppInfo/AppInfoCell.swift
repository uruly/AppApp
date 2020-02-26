//
//  AppInfoCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class AppInfoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.white
        //checkImageView.image = UIImage(named:"check2.png")?.withRenderingMode(.alwaysTemplate)
        //checkImageView.tintColor = UIColor.checkBtn()

        checkImageView.isHidden = true

        self.contentView.layer.cornerRadius = 30.0

        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
    }

}