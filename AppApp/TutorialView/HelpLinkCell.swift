//
//  HelpLinkCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class HelpLinkCell: UITableViewCell {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var linkBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.linkBtn.setTitleColor(UIColor.darkGray, for: .normal)
        self.linkBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.linkBtn.backgroundColor = UIColor.white
        self.linkBtn.layer.cornerRadius = 10
        //影をつける
        self.linkBtn.layer.masksToBounds = false
        self.linkBtn.layer.shadowColor = UIColor.darkGray.cgColor
        self.linkBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.linkBtn.layer.shadowRadius = 4
        self.linkBtn.layer.shadowOpacity = 0.5

        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.answerLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
