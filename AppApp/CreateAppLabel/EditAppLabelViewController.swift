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
                    if let items = naviBar.items,
                        items.count > 0 ,
                        let rightItem = items[0].rightBarButtonItem{
                        
                        rightItem.tintColor = UIColor.lightGray
                    }
                }else {
                    if let items = naviBar.items,
                        items.count > 0,
                        let rightItem = items[0].rightBarButtonItem{
                        
                        rightItem.tintColor = nil
                    }
                    //ポップアップで重複を知らせる
                }
            }else{
                if let items = naviBar.items,items.count > 0 ,
                    let rightItem = items[0].rightBarButtonItem{
                    rightItem.tintColor = UIColor.lightGray
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if naviBar.items != nil && naviBar.items!.count > 0{
            naviBar.items![0].title = "ラベルを編集"
        }
        colorPickerView.delegate = self
        labelName = currentName
        self.editTableView.isKeyboardAppear = false
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentName == "ALL" {
            print("ここ")
            editTableView.currentTextField?.isUserInteractionEnabled = false
        }
    }
    
    override func setTableView(){
        //tableViewを設置
        let width = self.view.frame.width
        let height = self.view.frame.height
        editTableView = EditAppLabelTableView(frame: CGRect(x:0,y:naviBar.frame.maxY,
                                                          width:width,
                                                          height:height - naviBar.frame.maxY),
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
        }
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
        //セーブをする
        AppLabel.saveLabelData(name: labelName!, color: color, id: id, order: order){
            BasePageViewController.isUnwind = true
            self.dismiss(animated:true,completion:nil)
        }
    }
}

class EditAppLabelTableView:CreateAppLabelTableView {
    
    var currentName:String!
    
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
    

    
}

