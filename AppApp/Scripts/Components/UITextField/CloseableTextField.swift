//
//  CloseableTextField.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class CloseableTextField: UITextField {

    var resignAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupToolbar()
    }

    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.backgroundColor = .white
        toolbar.isTranslucent = true
        let closeButton = UIBarButtonItem(title: "閉じる", style: .done, target: self, action: #selector(onTapCloseButton(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, closeButton], animated: false)
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }

    @objc func onTapCloseButton(_ sender: UIButton) {
        resignAction?()
        resignFirstResponder()
    }
}
