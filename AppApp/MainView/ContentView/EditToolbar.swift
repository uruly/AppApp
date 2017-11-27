//
//  EditToolbar.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/24.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol EditToolbarDelegate{
    @objc func addLabelBtnTapped()
    @objc func deleteAppBtnTapped()
    @objc func shareAppBtnTapped()
}


class EditToolbar: UIToolbar {

    var editDelegate:EditToolbarDelegate!{
        didSet{
            setup()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setup()
    }
    
    func setup(){
        let addLabelBtn = UIBarButtonItem(title: "ラベルを追加", style: .plain, target: editDelegate, action: #selector(editDelegate.addLabelBtnTapped))
        let deleteBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: editDelegate, action: #selector(editDelegate.deleteAppBtnTapped))
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: editDelegate, action: #selector(editDelegate.shareAppBtnTapped))
        
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.items = [shareBtn,flexible,addLabelBtn,flexible,deleteBtn]
    }

}
