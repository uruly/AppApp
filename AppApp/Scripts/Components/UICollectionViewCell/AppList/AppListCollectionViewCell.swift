//
//  AppListCollectionViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

final class AppListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!

    var imageMaskView: UIView!

    override var isSelected: Bool {
        didSet {
            checkImageView.isHidden = !isSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        checkImageView.isHidden = true

        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
    }

    func configure(app: App) {
        if let data = app.image {
            imageView.image = UIImage(data: data)
        }

    }

}
