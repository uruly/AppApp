//
//  LabelCollectionViewCell.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/28.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit
import SnapKit

protocol LabelCollectionViewCellDelegate: class {
    func toSettingLabelViewController(label: Label?, isNew: Bool)
}

final class LabelCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var addImageView: UIImageView!

    weak var delegate: LabelCollectionViewCellDelegate?

    var label: Label? {
        didSet {
            guard let label = label, let color = label.uiColor else { return }
            textLabel.text = label.name
            textLabel.textColor = UIColor.textColor(color)
            addImageView.isHidden = true
            contentView.backgroundColor = color
        }
    }

    private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        // iOS12 で幅がバグる対策
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.addGestureRecognizer(doubleTapGestureRecognizer)

        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label = nil
        addImageView.isHidden = true
    }

    func configureAddButton() {
        textLabel.text = ""
        contentView.backgroundColor = .gray
        addImageView.isHidden = false
    }

}

// MARK: - UIGestureRecognizer target

extension LabelCollectionViewCell {

    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        // ラベル設定画面に遷移
        guard let label = label else { return }
        delegate?.toSettingLabelViewController(label: label, isNew: false)
    }

}
