//
//  AppRealmData.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import Foundation
import RealmSwift

final class App: Object {

    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var developer: String = ""
    @objc dynamic var urlString: String = ""
    @objc dynamic var image: Data?
    @objc dynamic var date: Date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}
