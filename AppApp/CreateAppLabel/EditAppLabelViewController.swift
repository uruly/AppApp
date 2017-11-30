//
//  EditAppLabelViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/24.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class EditAppLabelViewController: CreateAppLabelViewController {

    var id:String!
    
    var currentName:String!
    var editTableView:EditAppLabelTableView!
    var editPickerView:EditAppOrderPickerView!
    
    override var color:UIColor{
        didSet{
            if editTableView == nil {
                return
            }
            editTableView.colorView.backgroundColor = color
        }
    }
    
    override var labelName:String!{
        didSet{
            if labelName != "" && labelName != nil{
                if AppLabel.contains(name: labelName!) && labelName != currentName{
                    if let rightItem = self.navigationItem.rightBarButtonItem{
                        
                        rightItem.tintColor = UIColor.lightGray
                    }
                }else {
                    if let rightItem = self.navigationItem.rightBarButtonItem{
                        
                        rightItem.tintColor = nil
                    }
                    //ポップアップで重複を知らせる
                }
            }else{
                if let rightItem = self.navigationItem.rightBarButtonItem{
                    rightItem.tintColor = UIColor.lightGray
                }
            }
        }
    }
    override var order:Int{
        didSet {
            if editTableView == nil {
                return
            }
            var text = "\(order)番目"
//            if order == (AppLabel.count ?? 1) - 1{
//                text = "最後に追加"
//            }
            editTableView.orderLabel.text = text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if self.navigationController?.navigationBar.items != nil && self.navigationController?.navigationBar.items!.count > 0{
//            naviBar.items![0].title = "ラベルを編集"
//        }
        self.title = "ラベルを編集"
        //pickerView.orderDelegate = self
        //colorPickerView.delegate = self
        labelName = currentName
        self.editTableView.isKeyboardAppear = false
        //currentRow = order
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if id == "0" {
            print("ここ")
            editTableView.currentTextField?.isUserInteractionEnabled = false
        }else {
            //orderの位置を設定
            var text = "\(order)番目"
            editTableView.orderLabel.text = text
        }
    }
    
    override func setTableView(){
        //tableViewを設置
        let width = self.view.frame.width
        let height = self.view.frame.height
        let naviBarHeight:CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 57.0
        editTableView = EditAppLabelTableView(frame: CGRect(x:0,y:naviBarHeight,
                                                          width:width,
                                                          height:height - naviBarHeight),
                                            createAppLabelVC:self)
        self.view.addSubview(editTableView)
        
        if id != "0"{
            let deleteBtn = UIButton(frame:CGRect(x:0,y:0,width:width,height:50))
            deleteBtn.center = CGPoint(x:width / 2,y:height - 25)
            deleteBtn.setTitle("ラベルを削除", for: .normal)
            
            deleteBtn.setTitleColor(UIColor.red, for: .normal)
            deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize:14)
            deleteBtn.addTarget(self, action: #selector(self.deleteBtnTapped), for: .touchUpInside)
            
            self.view.addSubview(deleteBtn)
        }else {
            //orderかえられないようにする
            editTableView.isAll = true
        }
        
        //ピッカービュー
        editPickerView = EditAppOrderPickerView(frame: CGRect(x:0,y:height,width:width,height:200))
        editPickerView.orderDelegate = self
        self.view.addSubview(editPickerView)
        
    }
    
    @objc override func cancelBtnTapped(){
        if editTableView != nil {
            if let textField = editTableView.currentTextField{
                textField.resignFirstResponder()
            }
            if let textView = editTableView.memoView {
                textView.resignFirstResponder()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func deleteBtnTapped(){
        //ポップアップを表示
        let alertController = UIAlertController(title: "ラベルを削除します。", message: "", preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "削除する", style: .default) {
            action in
            NSLog("はいボタンが押されました")
            self.deleteLabel()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) {
            action in NSLog("いいえボタンが押されました")
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteLabel(){
        AppLabel.deleteLabelData(labelID: id) {
            BasePageViewController.isUnwind = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func saveLabelData(){
        if editTableView != nil {
            if let textField = editTableView.currentTextField{
                textField.resignFirstResponder()
            }
            if let textView = editTableView.memoView {
                textView.resignFirstResponder()
            }
        }
        //セーブをする
        print(order)
        self.checkColor(color)
    }

    override func checkColor(_ color:UIColor) {
        if AppLabel.contains(color: color,isEdit:true,id:self.id) {
            //ポップアップを表示
            let alertController = UIAlertController(title: "この色はすでに使われています", message: "", preferredStyle: .alert)
            let otherAction = UIAlertAction(title: "このまま保存する", style: .default) {
                action in
                NSLog("はいボタンが押されました")
                AppLabel.updateLabelData(name: self.labelName!, color: self.color, id: self.id, order: self.order,explain:self.explain){
                    AppData.saveAppData(appList: self.appList, labelID: self.id) {
                        BasePageViewController.isUnwind = true
                        self.dismiss(animated:true,completion:nil)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "修正する", style: .cancel) {
                action in NSLog("いいえボタンが押されました")
            }
            
            alertController.addAction(otherAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else {
            AppLabel.updateLabelData(name: labelName!, color: color, id: id, order: order,explain:explain){
                AppData.saveAppData(appList: appList, labelID: id) {
                    BasePageViewController.isUnwind = true
                    self.dismiss(animated:true,completion:nil)
                }
            }
        }
    }
    
    
    override func showPicker(){
        let width = self.view.frame.width
        let height = self.view.frame.height
        //        print(currentRow)
        createFakeView(tag: 2)
        self.editPickerView.selectRow(order - 1, inComponent: 0, animated: false)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.editPickerView.frame = CGRect(x:0,y:height - 200,width:width,height:200)
        }, completion: nil)
    }
    
    override func closePicker(){
        let width = self.view.frame.width
        let height = self.view.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.editPickerView.frame = CGRect(x:0,y:height,width:width,height:200)
        }, completion: nil)
    }
}

class EditAppLabelTableView:CreateAppLabelTableView {
    
    var currentName:String!
    var isAll = false
    
    override var currentTextField:UITextField?{
        didSet {
            if currentTextField == nil { return }
            if currentTextField!.tag == 1 && currentName == "ALL"{
                currentTextField!.isUserInteractionEnabled = false
            }else if currentTextField!.tag == 1 {
                currentTextField!.text = createAppLabelVC.labelName
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isAll ? 2 : super.numberOfSections(in: tableView)
    }
    
    
}

class EditAppOrderPickerView:LabelOrderPickerView{
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //ラベルの数だけ
        let count =  AppLabel.count ?? 1
        return count - 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var text = "\(row + 1)番目"
//        if row + 1 == AppLabel.count {
//            text = "最後"
//        }
        return text
    }
}

