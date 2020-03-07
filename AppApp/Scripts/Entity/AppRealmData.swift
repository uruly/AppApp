//
//  AppRealmData.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import Foundation
import RealmSwift

final class AppRealmData: Object {

    @objc dynamic var name: String!      //アプリの名前
    @objc dynamic var developer: String!    //デベロッパ名
    @objc dynamic var id: String!        //アプリのid
    @objc dynamic var urlString: String!    //url
    @objc dynamic var image: Data!   //アイコンの画像
    @objc dynamic var date: Date!    //アプリを登録した日付

    override static func primaryKey() -> String? {
        return "id"
    }
}
