//
//  DetailMemoViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DetailMemoViewCell: UICollectionViewCell {

    //@IBOutlet weak var widthLayout: NSLayoutConstraint!

    @IBOutlet weak var tableView: LabelAppInfoView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //widthLayout.constant = UIScreen.main.bounds.width - 30
    }

}
