//
//  ColorSetCollectionViewCell.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

final class ColorSetCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var checkImageView: UIImageView!

    var color: Color?

    override var isSelected: Bool {
        didSet {
            checkImageView.isHidden = !isSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        checkImageView.isHidden = true

        checkImageView.image = R.image.check()!.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = UIColor.white
        self.contentView.layer.cornerRadius = 10.0

        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
    }

    func configure(color: Color) {
        contentView.backgroundColor = color.uiColor
        self.color = color
    }

}
