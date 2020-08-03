//
//  AppListTableViewCell.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppListTableViewCell: UITableViewCell {

    @IBOutlet private weak var appImageView: UIImageView!
    @IBOutlet private weak var appNameLabel: UILabel!

    var app: App?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        appImageView.image = nil
    }

    func configure(app: App) {
        if let imageData = app.image {
            appImageView.image = UIImage(data: imageData)
        }
        appNameLabel.text = app.name
        self.app = app
    }
}
