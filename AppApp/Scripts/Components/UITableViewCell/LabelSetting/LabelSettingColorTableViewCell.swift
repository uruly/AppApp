//
//  LabelSettingColorTableViewCell.swift
//  OKAIMO
//
//  Created by Reona Kubo on 2019/06/12.
//  Copyright © 2019 Reona Kubo. All rights reserved.
//

import UIKit

final class LabelSettingColorTableViewCell: UITableViewCell {

    @IBOutlet private weak var colorView: UIView!
    // ColorSet が設定されている時のみ表示する
    @IBOutlet private var colorViews: [UIView]!

    func set(_ viewController: LabelSettingViewController, color: UIColor?, colorSet: ColorSet?, text: String) {
        textLabel?.text = text
        textLabel?.isUserInteractionEnabled = false
        textLabel?.backgroundColor = .clear
        viewController.colorViewDelegate = self
        for view in colorViews {
            view.backgroundColor = colorSet?.getColor(view.tag)?.uiColor ?? .clear
            view.layer.cornerRadius = view.bounds.height / 2
        }
        colorView.layer.cornerRadius = colorView.bounds.height / 2
        colorView.backgroundColor = colorSet?.getColor(colorView.tag)?.uiColor ?? color
    }

}

// MARK: - LabelSettingColorViewDelegate

extension LabelSettingColorTableViewCell: LabelSettingColorViewDelegate {

    var color: UIColor? {
        return colorView.backgroundColor
    }

    func set(_ colorSet: ColorSet) {
        for view in colorViews {
            view.backgroundColor = colorSet.getColor(view.tag)?.uiColor
        }
        colorView.backgroundColor = colorSet.getColor(colorView.tag)?.uiColor
    }

    func set(_ color: Color) {
        for view in colorViews {
            view.backgroundColor = .clear
        }
        colorView.backgroundColor = color.uiColor
    }
}
