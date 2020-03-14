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

    @objc dynamic var id: String = ""
    @objc dynamic var app: AppRealmData?
    @objc dynamic var label: AppLabelRealmData?
    @objc dynamic var rate: Double = 0
    @objc dynamic var order: Int = 0
    @objc dynamic var memo: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension ApplicationData {

    static func getAll() -> Results<ApplicationData> {
        let objects = DatabaseManager.shared.objects(ApplicationData.self)
        return objects
    }

    static func get(_ label: AppLabelRealmData) -> [ApplicationData] {
        let sortProperties = [SortDescriptor(keyPath: "order", ascending: true)]
        let filter = NSPredicate(format: "label == %@", label)
        let objects = DatabaseManager.shared.objects(ApplicationData.self, filter: filter, sortedBy: sortProperties)
        return Array(objects)
    }

}
