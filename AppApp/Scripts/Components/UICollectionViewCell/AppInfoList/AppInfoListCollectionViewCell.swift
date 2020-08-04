//
//  AppInfoCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

final class AppInfoListCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var developerLabel: UILabel!
    @IBOutlet private weak var checkImageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            checkImageView.isHidden = !isSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.white

        checkImageView.isHidden = true

        contentView.layer.cornerRadius = 30.0

        // 影をつける
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(app: App) {
        if let imageData = app.image {
            imageView.image = UIImage(data: imageData)
        }
        if app.name == "" || app.developer == "" {
            AppRequest.shared.fetchApp(app: app)
        }
        nameLabel.text = app.name
        developerLabel.text = app.developer
    }
}
