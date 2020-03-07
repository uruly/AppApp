//
//  AppLabelRealmData.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

final class AppLabelRealmData: Object {

    @objc dynamic var name: String?      //ラベルの名前
    @objc dynamic var color: Data?    //ラベルの色
    @objc dynamic var id: String?        //id
    @objc dynamic var order = 0     //順番
    @objc dynamic var explain: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}
