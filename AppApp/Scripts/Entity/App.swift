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

    @objc dynamic var uid: String = ""
    @objc dynamic var appStoreID: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var developer: String = ""
    @objc dynamic var urlString: String = ""
    @objc dynamic var image: Data?
    @objc dynamic var rate: Double = 0
    @objc dynamic var order: Int = 0
    @objc dynamic var memo: String = ""
    @objc dynamic var date: Date = Date()

    override static func primaryKey() -> String? {
        return "uid"
    }

    convenience required init(uid: String, appStoreID: String, image: Data?) {
        self.init()
        self.uid = uid
        self.appStoreID = appStoreID
        self.image = image
    }
}

extension App {

    static func add(_ app: App) throws {
        try DatabaseManager.shared.add(app)
    }
}
