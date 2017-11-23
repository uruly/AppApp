//
//  AppData.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/23.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

//保存するアプリデータ
class AppRealmData : Object {
    @objc dynamic var name:String!      //アプリの名前
    @objc dynamic var developer:String!    //デベロッパ名
    @objc dynamic var id:String!        //アプリのid
    @objc dynamic var url:URL!    //ラベル内の順番
    @objc dynamic var date:Date!    //アプリを登録した日付
    //var labelList:List<AppLabelRealmData>?  //ラベルのリスト
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//アプリとラベルの紐付け
class ApplicationData: Object {
    var app:AppRealmData? = nil         //アプリデータ
    var label:AppLabelRealmData? = nil       //らベルデータ
    @objc dynamic var id:String!        //固有id UUID
    @objc dynamic var rate:Double = 0   //ラベルでのレート
    @objc dynamic var order:Int = 0     //ラベルでの場所
    @objc dynamic var memo:String?      //ラベルでのメモ
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
