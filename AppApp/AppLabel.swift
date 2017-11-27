//
//  AppLabel.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

//保存するデータ
class AppLabelRealmData : Object {
    @objc dynamic var name:String?      //ラベルの名前
    @objc dynamic var color:Data?    //ラベルの色
    @objc dynamic var id:String?        //id
    @objc dynamic var order = 0     //順番
    @objc dynamic var explain:String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//
struct AppLabelData {
    var name:String!
    var color:UIColor!
    var id:String!
    var order:Int!
    
//    var idNumber:Int? {
//        return Int(id)
//    }
}

class AppLabel {
    //全てのラベルデータを入れる
    var array:[AppLabelData] = []{
        didSet{
            AppLabel.count = array.count
        }
    }
    
    //現在のラベル
    static var currentID:String?
    static var currentOrder:Int?
    static var count:Int?
    
    init(){
        self.migration()
        self.reloadLabelData()
        if array.count == 0 {
            saveDefaultData()
        }
    }
    
    func migration(){
        var config =  Realm.Configuration(
            schemaVersion: SCHEMA_VERSION,
            migrationBlock: { migration, oldSchemaVersion in
                print(oldSchemaVersion)
                if (oldSchemaVersion < 4) {
                    migration.enumerateObjects(ofType: AppRealmData.className()) { oldObject, newObject in
                        print("migration")
                        
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
    }
    
    func reloadLabelData(){
        //ラベルを読み込む処理
        self.array = []
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
        let objs = realm.objects(AppLabelRealmData.self).sorted(by: sortProperties)
        for obj in objs{
            if let name = obj.name ,let colorData = obj.color,let id = obj.id{
                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                let label = AppLabelData(name: name, color: color, id: id,order: obj.order)
                self.array.append(label)
            }
        }
    }
    
    //一番最初に呼ばれる予定のデータ。Allが入る
    func saveDefaultData(){
        let name = "ALL"
        let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor.allLabel())
        let label = AppLabelRealmData(value:["name":name,
                                             "color":colorData,
                                             "id":"0",
                                             "order":0
            ])
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        try! realm.write {
            realm.add(label,update:true)
        }
        
        array.append(AppLabelData(name: name, color: UIColor.allLabel(), id: "0", order:0))
    }
    
    
    static func saveLabelData(name:String,color:UIColor,id:String,order:Int,_ completion:()->()){
        let colorData = NSKeyedArchiver.archivedData(withRootObject:color)
        let label = AppLabelRealmData(value:["name":name,
                                             "color":colorData,
                                             "id":id,
                                             "order":order
            ])
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        if order != AppLabel.count {
            //ほかの並びを更新
            let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
            let objects = realm.objects(AppLabelRealmData.self).sorted(by:sortProperties)
            for i in order ..< objects.count{
                try! realm.write {
                    objects[i].order = i + 1
                    realm.add(objects[i],update:true)
                }
            }
        }
        try! realm.write {
            realm.add(label,update:true)
        }
        completion()

    }
    
    static func updateLabelData(name:String,color:UIColor,id:String,order:Int,_ completion:()->()){
        let colorData = NSKeyedArchiver.archivedData(withRootObject:color)
        let label = AppLabelRealmData(value:["name":name,
                                             "color":colorData,
                                             "id":id,
                                             "order":order
            ])
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)

        guard let currentObject = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: id) else {
            return
        }
        
        if currentObject.order == order {
            try! realm.write {
                realm.add(label,update:true)
            }
        }else {
            //ほかの並びを更新
            let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
            let objects = realm.objects(AppLabelRealmData.self).sorted(by:sortProperties)
            if order < currentObject.order {
                for i in order ... currentObject.order {
                    try! realm.write {
                        objects[i].order = i + 1
                        realm.add(objects[i],update:true)
                    }
                }
            }else {
                for i in currentObject.order ... order{
                    try! realm.write {
                        objects[i].order = i - 1
                        realm.add(objects[i],update:true)
                    }
                }
            }
            
            try! realm.write {
                realm.add(label,update:true)
            }
        }
        
        completion()
        
    }

    
    static func contains(name:String) -> Bool{
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        let objs = realm.objects(AppLabelRealmData.self)
        for obj in objs{
            if obj.name == name {
                return true
            }
        }
        return false
    }
    
    static func deleteLabelData(labelID:String,_ completion:()->()){
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        guard let labelData = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: labelID) else{
            return
        }
        let appObjects = realm.objects(ApplicationData.self).filter("label == %@",labelData)
        for object in appObjects{
            try! realm.write {
                realm.delete(object)
            }
        }
        let deleteOrder = labelData.order
        try! realm.write {
            realm.delete(labelData)
        }
        //orderを直す
        let labelList = realm.objects(AppLabelRealmData.self)
        for label in labelList {
            if label.order > deleteOrder {
                try! realm.write{
                    label.order = label.order - 1
                    realm.add(label, update: true)
                }
            }
        }
        completion()
    }
    
    //並び順を更新
    func resetOrder(){
        for i in 1 ..< array.count {
            //appの並びを更新
            var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
            config.fileURL = url.appendingPathComponent("db.realm")
            
            let realm = try! Realm(configuration: config)
            guard let label = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: array[i].id) else {
                return
            }
            print(array[i].name)
            try! realm.write {
                label.order = i
                realm.add(label,update:true)
            }
            array[i].order = i
            
        }
    }
}

