//
//  ShareViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    
    lazy var ratingItem: SLComposeSheetConfigurationItem? = {
        guard let item = SLComposeSheetConfigurationItem() else {
            return nil
        }
        item.title = "評価"
        //item.value = "3"
        //item.tapHandler = self.showListViewControllerOfRating
        return item
    }()
    
    lazy var labelItem: SLComposeSheetConfigurationItem? = {
        guard let item = SLComposeSheetConfigurationItem() else {
            return nil
        }
        item.title = "ラベル"
        item.value = "ALL"      //userDefaultで保存しておきたい
        item.tapHandler = self.showLabelList
        return item
    }()
    
    lazy var memoItem: SLComposeSheetConfigurationItem? = {
        guard let item = SLComposeSheetConfigurationItem() else {
            return nil
        }
        item.title = "メモ"
        item.tapHandler = self.showMemoView
        return item
        
    }()
    
    var memoText:String = ""{
        didSet{
            memoItem?.value = memoText
        }
    }
    
    var labelList:[AppLabelData] = [] {
        didSet {
            labelItem?.value = ""
            for label in labelList {
                labelItem?.value = (labelItem?.value ?? "") + "【\(label.name!)】"
            }
        }
    }
    
    func showLabelList() {
        let labelListVC = LabelListTableViewController(style: .plain)
        labelListVC.delegate = self
        pushConfigurationViewController(labelListVC)
    }
    
    func showMemoView() {
        let memoVC = MemoViewController()
        memoVC.delegate = self
        pushConfigurationViewController(memoVC)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title = "Appを保存"
        let vc: UIViewController = self.navigationController!.viewControllers[0]
        vc.navigationItem.rightBarButtonItem!.title = "保存"
        self.textView.isUserInteractionEnabled = false
        //self.textView.canBecomeFirstResponder = false
    }
    
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.textView.resignFirstResponder()
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        //ポストを無効にする条件を書く
        
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        print(self.extensionContext?.inputItems.count)
        print(self.contentText)
        print("memoText\(self.memoText)")
        print("label\(labelList)")
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        
        return [labelItem,memoItem,ratingItem]
    }

}

extension ShareViewController:MemoViewDelegate{
    var shareVC:ShareViewController {
        return self
    }
}

extension ShareViewController:LabelListTableViewControllerDelegate {
//    var shareVC:ShareViewController {
//        return self
//    }
}

