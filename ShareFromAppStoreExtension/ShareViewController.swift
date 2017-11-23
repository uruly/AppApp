//
//  ShareViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import Social
import RealmSwift

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
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let itemProviders = extensionItem.attachments as! [NSItemProvider]
        loadData(itemProviders: itemProviders) { (name, developer, id, url, image) in
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            print("この中きたよ")
            self.saveAppData(name: name, developer: developer, id: id, url: url, image: image, date: Date())
        }
        
    }
    
    func loadData(itemProviders:[NSItemProvider],_ completion:@escaping (String,String,String,String,Data)->()){
        var name:String?
        var developer:String?
        var id:String?
        var url:String?
        var image:Data?
        //var date = Date()
        
        for itemProvider in itemProviders {
            print(itemProvider.registeredTypeIdentifiers)
            //URL
            if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
                print("ないの？")
                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: {
                    (item, error) in
                    
                    url = (item as? URL)!.absoluteString
                    //print("url\(url)")
                    
                    //let urlText = url!.absoluteString
                    if let idRange = url?.range(of: "id"),let endIndex = url?.index(of: "?"){
                        id = String(url![idRange.lowerBound ..< endIndex])
                        //print("id\(id)")
                    }
                    
                    if name != nil && developer != nil && id != nil && url != nil && image != nil {
                        completion(name!,developer!,id!,url!,image!)
                    }
                })
            }
            
            //IMAGE
            if (itemProvider.hasItemConformingToTypeIdentifier("public.image")) {
                itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil, completionHandler: {
                    (item, error) in
                    
                    // item にUIImageが入っている
                    let uiImage = item as! UIImage
                    image = UIImagePNGRepresentation(uiImage)
                    
                    if name != nil && developer != nil && id != nil && url != nil && image != nil {
                        completion(name!,developer!,id!,url!,image!)
                    }
                })
            }
            
            //PLAIN-TEXT
            if (itemProvider.hasItemConformingToTypeIdentifier("public.plain-text")) {
                itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: {
                    (item, error) in
                    
                    let text = item as! String
                    if text.contains("App名"){
                        let appLabelRange = text.range(of:"App名: ")
                        let developLabelRange = text.range(of:"、デベロッパ: ")
                        
                        //App名
                        var nameString = text[..<developLabelRange!.lowerBound]
                        nameString.removeSubrange(appLabelRange!)
                        print("name\(nameString)")
                        name = String(nameString)
                        
                        //デベロッパ名
                        let developString = text[developLabelRange!.upperBound ..< text.endIndex]
                        print("develop\(developString)")
                        developer = String(developString)
                        
                        if name != nil && developer != nil && id != nil && url != nil && image != nil {
                            completion(name!,developer!,id!,url!,image!)
                        }
                    }
                })
            }
        }
    }


    
    func saveAppData(name:String,developer:String,id:String,url:String,image:Data,date:Date){
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = false
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let appData = AppRealmData(value: ["name":name,
                                           "developer":developer,
                                           "id":id,
                                           "url":url,
                                           "image":image,
                                           "date":date])
        do{
            let realm = try Realm(configuration: config)
            do {
                try realm.write {
                    realm.add(appData,update:true)
                }
            }catch{
                print("error\(error)")
            }
        }catch{
            print(error)
        }
        
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

