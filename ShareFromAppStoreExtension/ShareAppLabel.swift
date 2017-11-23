//
//  ShareAppLabel.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/23.
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct AppLabelData {
    var name:String!
    var color:UIColor!
    var id:String!
    var order:Int!
}


