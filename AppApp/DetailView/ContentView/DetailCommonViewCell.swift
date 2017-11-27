//
//  DetailCommonViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DetailCommonViewCell: UICollectionViewCell {
    @IBOutlet weak var tableView: CommonInfoView!
    
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        widthLayout.constant = UIScreen.main.bounds.width - 30
    }

}
