//
//  FakeView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class FakeView: UIView {
    weak var delegate: CreateAppLabelViewController!
    var pickerTag: Int!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.delegate != nil {
            self.delegate.dismissPickerView(tag: pickerTag)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
}
