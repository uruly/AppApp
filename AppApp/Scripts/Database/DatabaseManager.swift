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

    private let schemaVersion: UInt64 = 6

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
        return .init { (migration, oldSchemaVersion) in
            if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: App.className()) { _, newObject in
                    newObject!["urlString"] = ""
                }
                migration.enumerateObjects(ofType: Label.className()) { _, newObject in
                    newObject!["explain"] = ""
                }
            }
        }
    }()
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
