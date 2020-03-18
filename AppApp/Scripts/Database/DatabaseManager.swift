//
//  DatabaseManager.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import Foundation
import RealmSwift

final class DatabaseManager {

    static let shared = DatabaseManager()

    private let schemaVersion: UInt64 = 13

    private var realm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private lazy var configuration: Realm.Configuration = {
        var configuration = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: migrationBlock)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: .groupID)
        configuration.fileURL = url?.appendingPathComponent("db.realm")

        return configuration
    }()

    private lazy var migrationBlock: RealmSwift.MigrationBlock? = {
        return .init { [weak self] (migration, oldSchemaVersion) in
            self?.migration(migration, from: oldSchemaVersion)
        }
    }()
}

// MARK: - Migration

extension DatabaseManager {

    private func migration(_ migration: Migration, from oldSchemaVersion: UInt64) {
        if oldSchemaVersion < 4 {
            migrationTo4(migration)
        }
        if oldSchemaVersion < 7 {
            migrationTo7(migration)
        }
        if oldSchemaVersion < 8 {
            migrationTo8(migration)
        }
        if oldSchemaVersion < 10 {
            migrationTo9(migration)
            migrationTo10(migration)
        }
        if oldSchemaVersion < 12 {
            migrationTo11(migration)
        }
    }

    private func migrationTo4(_ migration: Migration) {
        migration.enumerateObjects(ofType: "AppRealmData") { _, new in
            new!["urlString"] = ""
        }
        migration.enumerateObjects(ofType: "AppLabelRealmData") { _, new in
            new!["explain"] = ""
        }
    }

    private func migrationTo7(_ migration: Migration) {
        migration.enumerateObjects(ofType: "AppLabelRealmData") { (old, _) in
            let label = migration.create(Label.className())
            label["id"] = UUID().uuidString
            label["name"] = old?["name"]
            label["color"] = old?["color"]
            label["order"] = old?["order"]
            label["explain"] = old?["explain"]
        }
        migration.deleteData(forType: "AppLabelRealmData")
    }

    private func migrationTo8(_ migration: Migration) {
        migration.enumerateObjects(ofType: "AppRealmData") { (old, _) in
            let app = migration.create(App.className())
            app["uid"] = UUID().uuidString
            app["appStoreID"] = old?["id"]
            app["name"] = old?["name"]
            app["developer"] = old?["developer"]
            app["urlString"] = old?["urlString"]
            app["image"] = old?["image"]
            app["date"] = old?["date"]
        }
        migration.deleteData(forType: "AppRealmData")
    }

    private func migrationTo9(_ migration: Migration) {
        migration.enumerateObjects(ofType: "ApplicationData") { (old, _) in
            guard let oldApp = old?["app"] as? MigrationObject else {
                fatalError("Label not found")
            }
            let app = migration.create(App.className())
            app["uid"] = UUID().uuidString
            app["appStoreID"] = oldApp["id"]
            app["name"] = oldApp["name"]
            app["developer"] = oldApp["developer"]
            app["urlString"] = oldApp["urlString"]
            app["image"] = oldApp["image"]
            app["date"] = oldApp["date"]

            app["rate"] = old?["rate"]
            app["order"] = old?["order"]
            app["memo"] = old?["memo"]

            guard let oldLabel = old?["label"] as? MigrationObject else {
                fatalError("Label not found")
            }
            let label = migration.create(Label.className())
            label["id"] = UUID().uuidString
            label["name"] = oldLabel["name"]
            label["color"] = oldLabel["color"]
            label["order"] = oldLabel["order"]
            label["explain"] = oldLabel["explain"]
            app["label"] = label
            print("きたよ！", old)
        }
        migration.deleteData(forType: "ApplicationData")
    }

    private func migrationTo10(_ migration: Migration) {
        migration.enumerateObjects(ofType: App.className()) { (_, new) in
            new?["uid"] = UUID().uuidString
        }
    }

    private func migrationTo11(_ migration: Migration) {
        migration.enumerateObjects(ofType: Label.className()) { (_, new) in
            print("きったお")
            new?["id"] = UUID().uuidString
            print("e", new)
        }
    }
}

extension DatabaseManager {

    // MARK: - Fetch

    func object<T: Object>(_ type: T.Type, filter predicate: NSPredicate? = nil) -> T? {
        var results: Results<T>
        if let predicate = predicate {
            results = realm.objects(type).filter(predicate)
        } else {
            results = realm.objects(type)
        }

        return results.isEmpty ? nil : results.first
    }

    func objects<T: Object>(_ type: T.Type, filter predicate: NSPredicate? = nil, sortedBy properties: [SortDescriptor]? = nil) -> Results<T> {
        var results: Results<T>
        if let predicate = predicate {
            results = realm.objects(type).filter(predicate)
        } else {
            results = realm.objects(type)
        }

        if let propertiesSort = properties {
            results = results.sorted(by: propertiesSort)
        }
        return results
    }

    // MARK: - Add

    func add<T: Object>(_ object: T) {
        do {
            realm.beginWrite()
            realm.add(object, update: .all)
            try realm.commitWrite()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func add<T: RealmSwift.Object, S: Sequence>(_ objects: S) where S.Iterator.Element == T {
        do {
            realm.beginWrite()
            for item in objects {
                realm.add(item, update: .all)
            }
            try realm.commitWrite()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    // MARK: - Delete

    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func delete<T: RealmSwift.Object, S: Sequence>(_ objects: S) where S.Iterator.Element == T {
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
