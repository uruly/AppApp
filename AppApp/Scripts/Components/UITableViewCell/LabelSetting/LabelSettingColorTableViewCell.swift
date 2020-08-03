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

    func set(_ viewController: LabelSettingViewController, color: UIColor?, text: String) {
        textLabel?.text = text
        textLabel?.isUserInteractionEnabled = false
        textLabel?.backgroundColor = .clear
        colorView.layer.cornerRadius = colorView.bounds.height / 2
        colorView.backgroundColor = color
    }

}
