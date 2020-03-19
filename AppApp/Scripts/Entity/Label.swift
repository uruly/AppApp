//
//  Label.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

final class Label: Object {

    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var color: Data?
    @objc dynamic var order: Int = 0
    @objc dynamic var explain: String = ""

    let apps: List<App> = .init()

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Label {

    static func getAll() -> Results<Label> {
        return DatabaseManager.shared.objects(Label.self)
    }

    static func add(_ label: Label) throws {
        try DatabaseManager.shared.add(label)
    }

    static func remove(_ label: Label) throws {
        try DatabaseManager.shared.delete(label)
    }
}
