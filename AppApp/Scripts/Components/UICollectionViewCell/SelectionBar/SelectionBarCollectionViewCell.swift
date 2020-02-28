//
//  SelectionBarCollectionViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class SelectionBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //print("awakeFromNib")
        //layoutLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLabel()
    }

    func layoutLabel() {
        //角丸をつける
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.contentView.layer.mask = maskLayer

        //文字色どうしよう
        label.textColor = UIColor.white

        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
    }

}
