//
//  ColorSetViewCell.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class ColorSetViewCell: UICollectionViewCell {

    @IBOutlet weak var checkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkImageView.isHidden = true

        self.contentView.layer.cornerRadius = 10.0

        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
    }

}
