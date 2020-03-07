//
//  DatabaseManager.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import Foundation
import RealmSwift

struct DatabaseManager {

    static let shared = DatabaseManager()

    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
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
