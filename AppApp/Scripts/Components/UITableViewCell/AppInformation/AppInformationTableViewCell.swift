//
//  AppInformationTableViewCell.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppInformationTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!

    var data: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    func configure(title: String, data: String) {
        titleLabel.text = title
        dataLabel.text = data
        self.data = data
    }

}
