//
//  ApplicationData.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/23.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

final class ApplicationData: Object {

    @objc dynamic var app: AppRealmData?         //アプリデータ
    @objc dynamic var label: AppLabelRealmData?       //らベルデータ
    @objc dynamic var id: String!        //固有id UUID
    @objc dynamic var rate: Double = 0   //ラベルでのレート
    @objc dynamic var order: Int = 0     //ラベルでの場所
    @objc dynamic var memo: String?      //ラベルでのメモ

    override static func primaryKey() -> String? {
        return "id"
    }
}

struct AppStruct {
    var name: String!
    var developer: String!
    var id: String!
    var urlString: String!
    var image: Data!
    var date: Date!
}
