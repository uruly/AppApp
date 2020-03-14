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

extension AppRealmData {

    static func getAll() -> Results<AppRealmData> {
        let objects = DatabaseManager.shared.objects(AppRealmData.self)
        return objects
    }

    static func get(_ label: AppLabelRealmData) -> [AppRealmData] {
        let sortProperties = [SortDescriptor(keyPath: "order", ascending: true)]
        let filter = NSPredicate(format: "label == %@", label)
        let objects = DatabaseManager.shared.objects(AppRealmData.self, filter: filter, sortedBy: sortProperties)
        return Array(objects)
    }

}
