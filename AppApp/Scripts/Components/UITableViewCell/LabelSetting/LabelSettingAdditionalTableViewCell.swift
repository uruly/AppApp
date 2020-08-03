//
//  LabelSettingAdditionalTableViewCell.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class LabelSettingAdditionalTableViewCell: UITableViewCell {

    func set(text: String) {
        textLabel?.text = text
        accessoryType = .disclosureIndicator
    }
}
