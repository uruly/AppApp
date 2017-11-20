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
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//
struct AppLabelData {
    var name:String!
    var color:UIColor!
    var id:String!
    
    var idNumber:Int? {
        return Int(id)
    }
}

class AppLabel {
    //全てのラベルデータを入れる
    var array:[AppLabelData] = []
    
    //現在のラベル
    static var currentID:Int?
    
    init(){
        self.readLabelData()
        if array.count == 0 {
            saveDefaultData()
        }
    }
    
    func readLabelData(){
        //ラベルを読み込む処理
        self.array = []
        let realm = try! Realm()
        let objs = realm.objects(AppLabelRealmData.self)
        for obj in objs{
            if let name = obj.name ,let colorData = obj.color,let id = obj.id{
                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                let label = AppLabelData(name: name, color: color, id: id)
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
                                             "id":"0"
            ])
        let realm = try! Realm()
        try! realm.write {
            realm.add(label,update:true)
        }
        
        array.append(AppLabelData(name: name, color: UIColor.allLabel(), id: "0"))
    }
    
    static func saveLabelData(name:String,color:UIColor,id:String){
        let colorData = NSKeyedArchiver.archivedData(withRootObject:color)
        let label = AppLabelRealmData(value:["name":name,
                                             "color":colorData,
                                             "id":id
            ])
        let realm = try! Realm()
        try! realm.write {
            realm.add(label,update:true)
        }
    }
}

