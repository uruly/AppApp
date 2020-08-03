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

    private func showAlertIfNeeded() {
        guard let text = textField.text else { return }
        if text.count > 15 {
            let title = R.string.localizable.labelNameIsTooLong()
            let message = R.string.localizable.pleaseEnterLabelNameWithin15Characters()
            AlertViewController.show(title, message: message, alertType: .error)
            return
        }
        do {
            if try Label.isDuplicate(text, label: delegate?.currentLabel) {
                let title = R.string.localizable.labelNameIsDuplicated()
                let message = "\(text) " + R.string.localizable.isAlreadyInUseYouCanUseLabelsWithTheSameName()
                AlertViewController.show(title, message: message, alertType: .warning)
            }
        } catch {
            print("error", error)
        }
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
        showAlertIfNeeded()
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
