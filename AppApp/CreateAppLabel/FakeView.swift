//
//  FakeView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit


class FakeView: UIView {
    var delegate:CreateAppLabelViewController!
    var pickerTag:Int!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("多ｔｔぷ")
        if self.delegate != nil {
            self.delegate.dismissPickerView(tag:pickerTag)
        }
        print("タップされているよ")
        self.removeFromSuperview()
    }
}
