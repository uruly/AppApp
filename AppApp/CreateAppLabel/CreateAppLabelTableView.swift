//
//  CreateAppLabelTableView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class CreateAppLabelTableView: UITableView {

    var createAppLabelVC:CreateAppLabelViewController!
    var colorView:UIView!
    var orderLabel:UILabel!
    var currentTextField:UITextField?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "createAppLabel")
    }
    
    convenience init(frame:CGRect,createAppLabelVC:CreateAppLabelViewController){
        self.init(frame: frame, style: .grouped)
        self.createAppLabelVC = createAppLabelVC
    }

}

extension CreateAppLabelTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        if indexPath.section != 0{
            if let textField = currentTextField{
                textField.resignFirstResponder()
            }
        }
        if indexPath.section == 1{
            //カラーピッカーを表示
            print("colorPicker")
            createAppLabelVC.showColorPicker()
        }
        if indexPath.section == 2{
            print("uipickerを表示")
        }
    }
}

extension CreateAppLabelTableView:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1...3:return 1
        default:return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createAppLabel", for: indexPath)
        if indexPath.section == 0{
            let textField = UITextField(frame:cell.contentView.frame)
            textField.leftView = UIView(frame: CGRect(x:0,y:0,
                                                      width:15,height:cell.contentView.frame.height))
            textField.leftViewMode = UITextFieldViewMode.always
            textField.delegate = self
            textField.returnKeyType = .done
            textField.viewWithTag(5)
            if indexPath.row == 0 {
                textField.placeholder = "ラベル名"
                textField.tag = 1
                textField.becomeFirstResponder()
            }else if indexPath.row == 1 {
                textField.tag = 2
                textField.placeholder = "ラベルの説明(任意)"
            }
            cell.contentView.addSubview(textField)
        }
        
        //カラーを表示
        if indexPath.section == 1{
            cell.textLabel?.text = "カラー"
            colorView = UIView(frame: CGRect(x:0,y:0,width:20,height:20))
            colorView.backgroundColor = UIColor.blue
            colorView.layer.cornerRadius = 10
            cell.accessoryView = colorView
        }
        
        if indexPath.section == 2{
            cell.textLabel?.text = "並び順"
            orderLabel = UILabel(frame:CGRect(x:0,y:0,width:100,height:cell.contentView.frame.height))
            orderLabel.text = "最後に追加"
            orderLabel.textAlignment = .right
            cell.accessoryView = orderLabel
            
        }
        if indexPath.section == 3{
            cell.textLabel?.text = "Appを追加"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}

extension CreateAppLabelTableView:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.currentTextField = textField
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end")
        if textField.tag == 1 { //ラベル名
            createAppLabelVC.labelName = textField.text
        }
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateAppLabelTableView:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let textField = currentTextField{
            textField.resignFirstResponder()
        }
    }
}
