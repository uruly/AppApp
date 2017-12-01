//
//  LabelOrderPickerView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/25.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol LabelOrderPickerDelegate {
    func changedValue(_ order:Int)
}

class LabelOrderPickerView: UIPickerView {

    var orderDelegate:LabelOrderPickerDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        //self.selectRow(AppLabel.count ?? 0, inComponent: 0, animated: true)
    }
    
    
}

extension LabelOrderPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("row\(row)")
        //tableViewを更新
        if orderDelegate != nil {
            orderDelegate.changedValue(row + 1)
        }
    }
}

extension LabelOrderPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //ラベルの数だけ
        return AppLabel.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text = "\(row + 1)番目"
        if row + 1 == AppLabel.count {
            text = "最後"
        }
        return text
    }
}
