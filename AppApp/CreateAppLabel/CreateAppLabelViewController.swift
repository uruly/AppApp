//
//  CreateAppLabelViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class CreateAppLabelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = UIColor.backgroundGray()
        
        //ナビゲーションバーを設置
        let naviBarHeight = UIApplication.shared.statusBarFrame.height + 47.0
        print(naviBarHeight)
        let naviBar = CustomNavigationBar(frame: CGRect(x:0,y:0,width:width,height:naviBarHeight))
        let naviBarItem = UINavigationItem(title:"ラベルを追加")
        let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.cancelBtnTapped))
        let saveBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveBtnTapped))
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

    @objc func saveBtnTapped(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
