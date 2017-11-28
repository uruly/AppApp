//
//  DetailAppInfoViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DetailAppInfoViewCell: UICollectionViewCell {

    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    @IBOutlet weak var infoView: AppInfoView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        widthLayout.constant = UIScreen.main.bounds.width - 30
        infoView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30)
    }

}
