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
    static let count = Label.getAll().count

    override static func primaryKey() -> String? {
        return "id"
    }

    required convenience init(id: String, name: String, color: Data?, order: Int, explain: String) {
        self.init()
        self.id = id
        self.name = name
        self.color = color
        self.order = order
        self.explain = explain
    }

}

extension Label {

    var uiColor: UIColor? {
        guard let color = color else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: color)
    }
}

extension Label {

    static func getAll() -> [Label] {
        let sortProperties = [SortDescriptor(keyPath: "order", ascending: true)]
        return .init(DatabaseManager.shared.objects(Label.self, filter: nil, sortedBy: sortProperties))
    }

    static func getAllLabel() -> Label? {
        let predicate = NSPredicate(format: "id == %@", "ALLLABEL")
        return DatabaseManager.shared.object(Label.self, filter: predicate)
    }

    static func add(_ label: Label) throws {
        try DatabaseManager.shared.add(label)
    }

    static func update(_ label: Label, app: App) throws {
        let realm = DatabaseManager.shared.realm
        try realm.write {
            label.apps.append(app)
        }
    }

    static func remove(_ label: Label) throws {
        try DatabaseManager.shared.delete(label)
    }
}
