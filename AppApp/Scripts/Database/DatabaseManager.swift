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

    private let schemaVersion: UInt64 = 5

    private var realm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private lazy var configuration: Realm.Configuration = {
        var configuration = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: .groupID)!
        configuration.fileURL = url.appendingPathComponent("db.realm")

        return configuration
    }()
}

extension DatabaseManager {

    func object<T: Object>(_ type: T.Type, filter predicate: NSPredicate? = nil) -> T? {
        let results: Results<T>
        if let pre = predicate {
            results = realm.objects(type).filter(pre)
        } else {
            results = realm.objects(type)
        }

        guard !results.isEmpty else {
            return nil
        }
        return results.first
    }
}
