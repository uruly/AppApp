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
    var pickerView:LabelOrderPickerView!
    var isResetOrder = false
    //var currentRow:Int = AppLabel.count ?? 0
    
    var labelName:String?{
        didSet{
            if labelName != "" && labelName != nil{
                //すでにあったらno
                if !AppLabel.contains(name: labelName!){
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
    var order:Int = AppLabel.count ?? 1{
        didSet {
            if tableView == nil {
                return
            }
            var text = "\(order)番目に追加"
            if order == AppLabel.count {
                text = "最後に追加"
            }
            tableView.orderLabel.text = text
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
        
        setTableView()
        
        //カラーピッカー
        colorPickerView = ColorPicker()
        colorPickerView.frame = CGRect(x:0,
                                       y:height,
                                       width:width,
                                       height:200)
        colorPickerView.setup()
        colorPickerView.delegate = self
        self.view.addSubview(colorPickerView)
        
    }
    
    func setTableView(){
        //tableViewを設置
        let width = self.view.frame.width
        let height = self.view.frame.height
        tableView = CreateAppLabelTableView(frame: CGRect(x:0,y:naviBar.frame.maxY,
                                                          width:width,
                                                          height:height - naviBar.frame.maxY),
                                            createAppLabelVC:self)
        self.view.addSubview(tableView)
        
        //ピッカービュー
        pickerView = LabelOrderPickerView(frame: CGRect(x:0,y:height,width:width,height:200))
        pickerView.orderDelegate = self
        self.view.addSubview(pickerView)
    }
    
    @objc func cancelBtnTapped(){
        if tableView != nil {
            if let textField = tableView.currentTextField{
                textField.resignFirstResponder()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func saveBtnTapped(sender:UIBarButtonItem){
        if sender.tintColor != nil {
            return
        }
        //同じ色がすでに含まれていたらポップアップで確認を取る
        self.saveLabelData()
        
        
    }
    
    func saveLabelData(){
        //セーブをする
        let id = NSUUID().uuidString
        AppLabel.saveLabelData(name: labelName!, color: color, id: id, order: order){
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
    
    func showPicker(){
        let width = self.view.frame.width
        let height = self.view.frame.height
//        print(currentRow)
        self.pickerView.selectRow(order, inComponent: 0, animated: false)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.pickerView.frame = CGRect(x:0,y:height - 200,width:width,height:200)
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
extension CreateAppLabelViewController: LabelOrderPickerDelegate {
    func changedValue(_ order: Int) {
        //orderLabel.text = text
        print("changed\(order)")
        self.order = order
    }
}

