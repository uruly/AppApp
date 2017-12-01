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
    
    
    func isAppStore(_ completion:@escaping (Int)->()){
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
       // var bool = false
        let itemProviders = extensionItem.attachments as! [NSItemProvider]
        if !itemProviders.contains(where: { (itemProvider) -> Bool in
            return itemProvider.hasItemConformingToTypeIdentifier("public.url")
        }){
            completion(1)
        }
        for itemProvider in itemProviders {
            //print(itemProvider.registeredTypeIdentifiers)
            //URL
            if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: {
                    (item, error) in
                    
                    let url = (item as? URL)!.absoluteString
                    if url.contains("itunes.apple.com"){
                        if url.contains("story"){
                            completion(2)
                        }else {
                            completion(0)
                        }
                    }else {
                        completion(1)
                    }
                })
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.textView.resignFirstResponder()
        isAppStore { (tag) in
            if tag == 1 {
                self.showAlert()
            }else if tag == 2{
                self.showStoryAlert()
            }
        }
    }
    
    func showAlert(){
        //ポップアップを表示
        let alertController = UIAlertController(title: "利用できません", message: "この機能はAppStoreでのみ利用できます。", preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "了解", style: .destructive) {
            action in NSLog("はいボタンが押されました")
            self.cancel()
        }
        
        alertController.addAction(otherAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func showStoryAlert(){
        //ポップアップを表示
        let alertController = UIAlertController(title: "利用できません", message: "ストーリーは保存できません。", preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "了解", style: .destructive) {
            action in NSLog("はいボタンが押されました")
            self.cancel()
        }
        
        alertController.addAction(otherAction)
        
        self.present(alertController, animated: true, completion: nil)
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
            //print("この中きたよ")
            print("name\(name),url\(url)")
            self.saveAppData(name: name, developer: developer, id: id, urlString: url, image: image)
        }
        //失敗したときにもこれ呼ばんと固まる
        //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
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
                //print("ないの？")
                itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: {
                    (item, error) in
                    
                    url = (item as? URL)!.absoluteString
                    print("url\(url)")
                    
                    //let urlText = url!.absoluteString
                    if let idRange = url?.range(of: "id"),let endIndex = url?.index(of: "?"){
                        id = String(url![idRange.lowerBound ..< endIndex])
                        //print("id\(id)")
                    }
                    
                    if name != nil && developer != nil && id != nil && url != nil && image != nil {
                        completion(name!,developer!,id!,url!,image!)
                    }
                     print("error\(error)")
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
                     print("error\(error)")
                })
            }
            
            //PLAIN-TEXT
            if (itemProvider.hasItemConformingToTypeIdentifier("public.plain-text")) {
                itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: {
                    (item, error) in
                    
                    let text = item as! String
                    print(text)
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
                        //print("develop\(developString)")
                        developer = String(developString)
                        
                        if name != nil && developer != nil && id != nil && url != nil && image != nil {
                            completion(name!,developer!,id!,url!,image!)
                        }
                    }else if text.contains("by") {
                        //let appLabelRange = text.range(of:"")
                        let developLabelRange = text.range(of:"by")
                        
                        //App名
                        let nameString = text[..<developLabelRange!.lowerBound]
                        //nameString.removeSubrange(appLabelRange!)
                        print("name\(nameString)")
                        name = String(nameString)
                        
                        //デベロッパ名
                        let developString = text[developLabelRange!.upperBound ..< text.endIndex]
                        //print("develop\(developString)")
                        developer = String(developString)
                        
                        if name != nil && developer != nil && id != nil && url != nil && image != nil {
                            completion(name!,developer!,id!,url!,image!)
                        }
                    }
                    print("error\(error)")
                })
            }
        }
    }


    
    //AppのDataをセーブするよ
    func saveAppData(name:String,developer:String,id:String,urlString:String,image:Data){
        var config =  Realm.Configuration(
            schemaVersion: SCHEMA_VERSION,
            migrationBlock: { migration, oldSchemaVersion in
                //print(oldSchemaVersion)
                if (oldSchemaVersion < 4) {
                    migration.enumerateObjects(ofType: AppRealmData.className()) { oldObject, newObject in
                        //print("migration")
                        
                        newObject!["urlString"] = ""
                    }
                    migration.enumerateObjects(ofType: AppLabelRealmData.className()){ oldObject,newObject in
                        newObject!["explain"] = ""
                    }
                }
        })
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        Realm.Configuration.defaultConfiguration = config
        
        var date = Date()
        let realm = try! Realm()
        if let object = realm.object(ofType: AppRealmData.self, forPrimaryKey: id){
            date = object.date
        }
        let appData = AppRealmData(value: ["name":name,
                                           "developer":developer,
                                           "id":id,
                                           "urlString":urlString,
                                           "image":image,
                                           "date":date])
        try! realm.write {
            realm.add(appData,update:true)
        }
        saveLabelAppData(appData:appData)
    }
    
    func saveAllLabel(appData:AppRealmData){
        let realm = try! Realm()
        var labelRealm:AppLabelRealmData
        if let all = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: "0") {
            labelRealm = all
        }else {
            //allがない時
            let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1))
            labelRealm = AppLabelRealmData(value:["name":"ALL",
                                                  "color":colorData,
                                                  "id":"0",
                                                  "order":0
                ])
        }
        var id = UUID().uuidString
        var order = self.dataCount(label:labelRealm)
        if contains(labelID: labelRealm.id!, appID: appData.id){
            //すでにあるidをつける
            let objs = realm.objects(ApplicationData.self)
            for obj in objs {
                if obj.app!.id == appData.id && obj.label!.id == labelRealm.id!  {
                    id = obj.id
                    order = obj.order
                    break
                }
            }
        }
        let data = ApplicationData(value: ["app":appData,
                                           "label":labelRealm,
                                           "id":id,
                                           "rate":0,
                                           "order":order,
                                           "memo":memoText])
        
        try! realm.write {
            realm.add(data,update:true)
        }
        print("seikou?")
    }
    //Appとラベルを紐づけたのを保存するよ
    func saveLabelAppData(appData:AppRealmData){
        
        saveAllLabel(appData:appData)
        let index = labelList.findIndex(includeElement: {$0.name == "ALL"})
        if index.count > 0 {
            //print("all消すよ")
            labelList.remove(at: index[0])
        }
        
        for label in labelList {
            //print("label.name:\(label.name)")
            let colorData = NSKeyedArchiver.archivedData(withRootObject: label.color)
            let labelRealm = AppLabelRealmData(value:["name":label.name,
                                                      "color":colorData,
                                                      "id":label.id,
                                                      "order":label.order
                ])
            var id = UUID().uuidString
            var order = self.dataCount(label:labelRealm)
            let realm = try! Realm()
            if contains(labelID: labelRealm.id!, appID: appData.id){
                //すでにあるidをつける
                let objs = realm.objects(ApplicationData.self)
                for obj in objs {
                    if obj.app!.id == appData.id && obj.label!.id == labelRealm.id! {
                        id = obj.id
                        order = obj.order
                    }
                }
            }
            let data = ApplicationData(value: ["app":appData,
                                               "label":labelRealm,
                                               "id":id,
                                               "rate":0,
                                               "order":order,
                                               "memo":memoText])
            
            try! realm.write {
                realm.add(data,update:true)
            }
            print("成功?")
        }
    }
    
    func dataCount(label:AppLabelRealmData) -> Int {
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        guard let labelData = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: label.id) else {
            return 0
        }
        
        let objs = realm.objects(ApplicationData.self).filter("label == %@",labelData)
        //print("objs.count\(objs.count)")
        return objs.count
    }

    func contains(labelID:String,appID:String) -> Bool{
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        guard let _ = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: labelID) else{
            return false
        }
        guard let _ = realm.object(ofType: AppRealmData.self, forPrimaryKey: appID) else {
            return false
        }
        //print("app.name\(app.name),label\(label.name!)")
        return true
    }
    
    
    override func configurationItems() -> [Any]! {
        
        return [labelItem!,memoItem!]
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

