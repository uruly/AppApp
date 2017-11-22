//
//  CreateAppLabelViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class CreateAppLabelViewController: UIViewController {

    var naviBar:CustomNavigationBar!
    var tableView:CreateAppLabelTableView!
    var pickerView:UIPickerView!
    
    var labelName:String?{
        didSet{
            if labelName != "" && labelName != nil{
                //trueなら保存できる
                if AppLabel.contains(name: labelName!){
                    if let items = naviBar.items,let rightItem = items[0].rightBarButtonItem{
                        rightItem.tintColor = nil
                    }
                }else {
                    if let items = naviBar.items,let rightItem = items[0].rightBarButtonItem{
                        rightItem.tintColor = UIColor.lightGray
                    }
                    //ポップアップで重複を知らせる
                }
            }else{
                if let items = naviBar.items,let rightItem = items[0].rightBarButtonItem{
                    rightItem.tintColor = UIColor.lightGray
                }
            }
        }
    }
    
    var color:UIColor = UIColor.blue{
        didSet{
            if tableView == nil {
                return
            }
            tableView.colorView.backgroundColor = color
        }
    }
    
    var colorPickerView:ColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = UIColor.backgroundGray()
        
        //ナビゲーションバーを設置
        let naviBarHeight = UIApplication.shared.statusBarFrame.height + 47.0
        print(naviBarHeight)
        naviBar = CustomNavigationBar(frame: CGRect(x:0,y:0,width:width,height:naviBarHeight))
        let naviBarItem = UINavigationItem(title:"ラベルを追加")
        let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.cancelBtnTapped))
        let saveBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveBtnTapped(sender:)))
        saveBtn.tintColor = UIColor.lightGray    //まだ押せない
        naviBarItem.leftBarButtonItem = cancelBtn
        naviBarItem.rightBarButtonItem = saveBtn
        naviBar.items = [naviBarItem]
        self.view.addSubview(naviBar)
        
        //tableViewを設置
        tableView = CreateAppLabelTableView(frame: CGRect(x:0,y:naviBar.frame.maxY,
                                                              width:width,
                                                              height:height - naviBar.frame.maxY),
                                                createAppLabelVC:self)
        self.view.addSubview(tableView)
        
        //カラーピッカー
        colorPickerView = ColorPicker()
        colorPickerView.frame = CGRect(x:0,
                                       y:height,
                                       width:width,
                                       height:200)
        colorPickerView.setup()
        colorPickerView.delegate = self
        self.view.addSubview(colorPickerView)
        
        //ピッカービュー
        pickerView = UIPickerView(frame: CGRect(x:0,y:height,width:width,height:200))
    }
    
    @objc func cancelBtnTapped(){
        if let textField = tableView.currentTextField{
            textField.resignFirstResponder()
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func saveBtnTapped(sender:UIBarButtonItem){
        if sender.tintColor != nil {
            return
        }
        //同じ色がすでに含まれていたらポップアップで確認を取る
        
        
        //セーブをする
        let id = NSUUID().uuidString
        AppLabel.saveLabelData(name: labelName!, color: color, id: id, order: AppLabel.count!){
            BasePageViewController.isUnwind = true
            self.dismiss(animated:true,completion:nil)
        }
        
        
    }
    
    func showColorPicker(){
        let width = self.view.frame.width
        let height = self.view.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.colorPickerView.frame = CGRect(x:0,y:height - 200,width:width,height:200)
        }, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CreateAppLabelViewController:ColorDelegate {
    func pickedColor(color:UIColor,endState:Bool){
        print("color\(color)")
        self.color = color
    }
}

