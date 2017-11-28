//
//  DeleteViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/28.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DeleteViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: DeleteAppView!
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //widthLayout.constant = UIScreen.main.bounds.width - 30
        //tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //ここでcellの大きさを変えたい
        self.sizeToFit()
        print("layoutSubviewだよ")
    }

}
