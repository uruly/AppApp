//
//  InfoTableViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDoneBtn(textField)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDoneBtn(_ textField:UITextField){
        // 仮のサイズでツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = .default  // スタイルを設定
        toolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneBtnTapped(sender:)))
        toolBar.items = [spacer, commitButton]
        
        
        textField.inputAccessoryView = toolBar
        textField.returnKeyType = .done
    }
    
    @objc func doneBtnTapped(sender:UIBarButtonItem) {
        textField.resignFirstResponder()
    }
    
}
