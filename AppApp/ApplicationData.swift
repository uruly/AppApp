//
//  ApplicationData.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/23.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

let SCHEMA_VERSION:UInt64 = 4

//保存するアプリデータ
class AppRealmData : Object {
    @objc dynamic var name:String!      //アプリの名前
    @objc dynamic var developer:String!    //デベロッパ名
    @objc dynamic var id:String!        //アプリのid
    @objc dynamic var urlString:String!    //url
    @objc dynamic var image:Data!   //アイコンの画像
    @objc dynamic var date:Date!    //アプリを登録した日付
    //var labelList:List<AppLabelRealmData>?  //ラベルのリスト
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//アプリとラベルの紐付け
class ApplicationData: Object {
    @objc dynamic var app:AppRealmData? = nil         //アプリデータ
    @objc dynamic var label:AppLabelRealmData? = nil       //らベルデータ
    @objc dynamic var id:String!        //固有id UUID
    @objc dynamic var rate:Double = 0   //ラベルでのレート
    @objc dynamic var order:Int = 0     //ラベルでの場所
    @objc dynamic var memo:String?      //ラベルでのメモ
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct AppStruct {
    var name:String!
    var developer:String!
    var id:String!
    var urlString:String!
    var image:Data!
    var date:Date!
}

struct ApplicationStruct{
    var app:AppStruct!
    var label:AppLabelData!
    var id:String!
    var rate:Double?
    var order:Int!
    var memo:String?
}


//ApplicationDataを保存
class AppData {
    
    //label
    var label:AppLabelData!
    
    var appList:[ApplicationStruct]!
    
    init(label:AppLabelData) {
        self.label = label
        readAppData(label:label)
    }
    
//    init(allLabel:AppLabelData){
//        self.label = allLabel
//        readAllAppData()
//    }
    
    //読み込み
    func readAppData(label:AppLabelData){
        appList = []
        
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        
        //先にラベルを取得
        guard let labelObject = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: label.id) else {
            return
        }
        let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
        let objs = realm.objects(ApplicationData.self).filter("label == %@",labelObject).sorted(by:sortProperties)
        for obj in objs {
            //applicationStruct
            guard let app = obj.app else{ return }
            let appData = AppStruct(name: app.name, developer: app.developer, id: app.id, urlString: app.urlString, image: app.image, date: app.date)
            
            let appLabel = ApplicationStruct(app: appData, label: label, id: obj.id, rate: obj.rate, order: obj.order, memo: obj.memo)
            
            appList.append(appLabel)
            
        }
        
    }
    
    //並び順を更新
    func resetOrder(){
        for i in 0 ..< appList.count {
            //appの並びを更新
            var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
            config.fileURL = url.appendingPathComponent("db.realm")

            let realm = try! Realm(configuration: config)
            guard let app = realm.object(ofType: ApplicationData.self, forPrimaryKey: appList[i].id) else {
                return
            }
            try! realm.write {
                app.order = i
                realm.add(app,update:true)
            }
            
        }
    }
}
