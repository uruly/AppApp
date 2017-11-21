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
        let tableView = CreateAppLabelTableView(frame: CGRect(x:0,y:naviBar.frame.maxY,
                                                              width:width,
                                                              height:height - naviBar.frame.maxY),
                                                createAppLabelVC:self)
        self.view.addSubview(tableView)
        
    }
    
    @objc func cancelBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func saveBtnTapped(sender:UIBarButtonItem){
        if sender.tintColor != nil {
            return
        }
        print("nilおｋ！")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
