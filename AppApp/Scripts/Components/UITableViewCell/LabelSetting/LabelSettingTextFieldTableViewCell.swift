//
//  LabelSettingTextFieldTableViewCell.swift
//  OKAIMO
//
//  Created by Reona Kubo on 2019/06/12.
//  Copyright © 2019 Reona Kubo. All rights reserved.
//

import UIKit

protocol LabelSettingTextFieldTableViewCellDelegate: class {

    var currentLabel: Label { get }
    func changedLabel(_ text: String)
}

final class LabelSettingTextFieldTableViewCell: UITableViewCell {

    weak var delegate: LabelSettingTextFieldTableViewCellDelegate?

    @IBOutlet private(set) weak var textField: CloseableTextField! {
        didSet {
            textField.delegate = self
            textField.resignAction = { [weak self] in
                self?.closeKeyboard(true)
            }
        }
    }

    func set(_ viewController: LabelSettingViewController, text: String) {
        textField.text = text
        viewController.textFieldDelegate = self
    }

    @IBAction func didChange(_ sender: UITextField) {
        guard let text = textField.text else { return }
        delegate?.changedLabel(text)
    }

}

// MARK: - LabelSettingTextFieldDelegate

extension LabelSettingTextFieldTableViewCell: LabelSettingTextFieldDelegate {

    func closeKeyboard(_ alertEnabled: Bool) {
        guard alertEnabled && textField.isFirstResponder else {
            textField.resignFirstResponder()
            return
        }
        textField.resignFirstResponder()
    }

    var labelName: String? {
        return textField.text
    }
}

// MARK: - UITextFieldDelegate

extension LabelSettingTextFieldTableViewCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeKeyboard(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        closeKeyboard(false)
    }

}
