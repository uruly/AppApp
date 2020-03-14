//
//  AppLabel.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import RealmSwift
import UIKit

class AppLabel {
    //全てのラベルデータを入れる
    var array: [AppLabelRealmData] = [] {
        didSet {
            AppLabel.count = array.count
        }
    }

    //現在のラベル
    static var currentID: String?
    static var currentOrder: Int?
    static var count: Int?
    static var currentColor: UIColor?
    static var currentBackgroundColor: UIColor? {
        didSet {
            let userDefaults = UserDefaults.standard
            if let color = AppLabel.currentBackgroundColor {
                let data = NSKeyedArchiver.archivedData(withRootObject: color)
                userDefaults.set(data, forKey: "backgroundColor")
            } else {
                userDefaults.removeObject(forKey: "backgroundColor")
            }

        }
    }
    static var currentBackgroundImage: UIImage? {
        didSet {
            let userDefaults = UserDefaults.standard
            if let image = AppLabel.currentBackgroundImage {
                let data = image.pngData()
                //print("保存してるよ")
                userDefaults.set(data, forKey: "backgroundImage")
            } else {
                userDefaults.removeObject(forKey: "backgroundImage")
            }

        }
    }

    init() {
        self.migration()
        self.reloadLabelData()
        //        if array.count == 0 {
        //            saveDefaultData()
        //        }
        let userDefaults = UserDefaults.standard
        if let colorData = userDefaults.data(forKey: "backgroundColor") {
            AppLabel.currentBackgroundColor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        if let backImageData = userDefaults.data(forKey: "backgroundImage") {
            //print("imageDataあるよ")
            AppLabel.currentBackgroundImage = UIImage(data: backImageData )
        }
    }

    func migration() {
        var config =  Realm.Configuration(
            schemaVersion: .schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                //print(oldSchemaVersion)
                if oldSchemaVersion < 4 {
                    migration.enumerateObjects(ofType: AppRealmData.className()) { _, newObject in
                        //print("migration")

                        newObject!["urlString"] = ""
                    }
                    migration.enumerateObjects(ofType: AppLabelRealmData.className()) { _, newObject in
                        newObject!["explain"] = ""
                    }
                }
        })
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        Realm.Configuration.defaultConfiguration = config
    }

    func reloadLabelData() {
        DispatchQueue.main.async {
            let sortProperties = [SortDescriptor(keyPath: "order", ascending: true)]
            let objects = DatabaseManager.shared.objects(AppLabelRealmData.self, filter: nil, sortedBy: sortProperties)
            print(objects)
            self.array = Array(objects)
        }
        //        //ラベルを読み込む処理
        //        self.array = []
        //        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        //        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        //        config.fileURL = url.appendingPathComponent("db.realm")
        //
        //        let realm = try! Realm(configuration: config)
        //        let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
        //        let objs = realm.objects(AppLabelRealmData.self).sorted(by: sortProperties)
        //        for obj in objs {
        //            if let name = obj.name, let colorData = obj.color, let id = obj.id {
        //                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
        //                let label = AppLabelData(name: name, color: color, id: id, order: obj.order, explain: obj.explain)
        //                self.array.append(label)
        //            }
        //        }
    }

    //一番最初に呼ばれる予定のデータ。Allが入る
    func saveDefaultData() {
        //        let name = "ALL"
        //        let colorData = NSKeyedArchiver.archivedData(withRootObject: R.color.mainBlueColor())
        //        let label = AppLabelRealmData(value: ["name": name,
        //                                              "color": colorData,
        //                                              "id": "0",
        //                                              "order": 0
        //        ])
        //        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        //        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        //        config.fileURL = url.appendingPathComponent("db.realm")
        //
        //        let realm = try! Realm(configuration: config)
        //        try! realm.write {
        //            realm.add(label, update: .all)
        //        }

        //        array.append(AppLabelData(name: name, color: R.color.mainBlueColor(), id: "0", order: 0, explain: "全てのApp"))
    }

    static func saveLabelData(name: String, color: UIColor, id: String, order: Int, explain: String?, _ completion:() -> Void) {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        let label = AppLabelRealmData(value: ["name": name,
                                              "color": colorData,
                                              "id": id,
                                              "order": order,
                                              "explain": explain ?? ""
        ])
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)
        if order != AppLabel.count {
            //ほかの並びを更新
            let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
            let objects = realm.objects(AppLabelRealmData.self).sorted(by: sortProperties)
            try! realm.write {
                objects.map { object in
                    // 変更した order より大きいものだけ並び替える
                    if object.order > order { return }
                    let newObject = object
                    newObject.order = object.order + 1
                    realm.add(newObject, update: .all)
                }
            }
        }
        try! realm.write {
            realm.add(label, update: .all)
        }
        completion()

    }

    static func updateLabelData(name: String, color: UIColor, id: String, order: Int, explain: String?, _ completion:() -> Void) {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        let label = AppLabelRealmData(value: ["name": name,
                                              "color": colorData,
                                              "id": id,
                                              "order": order,
                                              "explain": explain ?? ""
        ])
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)

        guard let currentObject = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: id) else {
            return
        }

        if currentObject.order == order {
            try! realm.write {
                realm.add(label, update: .all)
            }
        } else {
            //ほかの並びを更新
            let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
            let objects = realm.objects(AppLabelRealmData.self).sorted(by: sortProperties)
            if order < currentObject.order {
                try! realm.write {
                    objects.map { object in
                        if object.order < currentObject.order { return }
                        let newObject = object
                        newObject.order += 1
                        realm.add(object, update: .all)
                    }
                }
            } else {
                try! realm.write {
                    objects.map { object in
                        if object.order >= currentObject.order { return }
                        let newObject = object
                        newObject.order -= 1
                        realm.add(object, update: .all)
                    }
                }
            }

            try! realm.write {
                realm.add(label, update: .all)
            }
        }

        completion()

    }

    static func contains(name: String) -> Bool {
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)
        let objs = realm.objects(AppLabelRealmData.self)
        for obj in objs where obj.name == name {
            return true
        }
        return false
    }

    static func contains(color: UIColor, isEdit: Bool, id: String) -> Bool {
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)
        let objs = realm.objects(AppLabelRealmData.self)
        for obj in objs {
            if let objColor = NSKeyedUnarchiver.unarchiveObject(with: obj.color!) as? UIColor {
                if objColor.compare(color) {
                    //print("同じ色")
                    if isEdit {
                        //自身と同じ色ならcontinue
                        if obj.id == id {
                            continue
                        } else {
                            return true
                        }

                    } else {
                        return true
                    }
                }
            }
        }
        //print("先にfalse呼ばれてる？")
        return false
    }

    static func deleteLabelData(labelID: String, _ completion:() -> Void) {
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)
        guard let labelData = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: labelID) else {
            return
        }
        let appObjects = realm.objects(ApplicationData.self).filter("label == %@", labelData)
        for object in appObjects {
            try! realm.write {
                realm.delete(object)
            }
        }
        let deleteOrder = labelData.order
        try! realm.write {
            realm.delete(labelData)
        }
        // orderを直す
        let labelList = realm.objects(AppLabelRealmData.self)
        for label in labelList where label.order > deleteOrder {
            try! realm.write {
                label.order -= 1
                realm.add(label, update: .all)
            }
        }
        completion()
    }

    //並び順を更新
    func resetOrder() {
        for (index, app) in array.enumerated() {
            if index == 0 { continue }
            var config = Realm.Configuration(schemaVersion: .schemaVersion)
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
            config.fileURL = url.appendingPathComponent("db.realm")

            let realm = try! Realm(configuration: config)
            guard let label = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: app.id) else {
                return
            }
            //print(array[i].name)
            try! realm.write {
                label.order = index
                realm.add(label, update: .all)
            }
            array[index].order = index
        }
    }
}
