//
//  AppData.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/03/07.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import Foundation
import RealmSwift

//ApplicationDataを保存
class AppData {

    //label
    var label: Label!

    //    var appList: [ApplicationData]!

    init(label: Label) {
        self.label = label
        readAppData(label: label) {
            //print("読み込み完了")
        }
    }

    //    init(allLabel:AppLabelData){
    //        self.label = allLabel
    //        readAllAppData()
    //    }

    //読み込み
    func readAppData(label: Label, _ completion:@escaping () -> Void) {
        //        appList = Array(ApplicationData.getAll())

        //        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        //        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        //        config.fileURL = url.appendingPathComponent("db.realm")
        //        let realm = try! Realm(configuration: config)
        //
        //        //先にラベルを取得
        //        guard let labelObject = realm.object(ofType: Label.self, forPrimaryKey: label.id) else {
        //            return
        //        }
        //        let sortProperties = [SortDescriptor(keyPath: "order", ascending: true) ]
        //        let objs = realm.objects(ApplicationData.self).filter("label == %@", labelObject).sorted(by: sortProperties)
        //        for obj in objs {
        //            //applicationStruct
        //            guard let app = obj.app else { return }
        //            let appData = AppStruct(name: app.name, developer: app.developer, id: app.id, urlString: app.urlString, image: app.image, date: app.date)
        //
        //
        //            let appLabel = ApplicationData(app: appData, label: label, id: obj.id, rate: obj.rate, order: obj.order, memo: obj.memo)
        //
        //            self.appList.append(appLabel)
        //        }
        //reloadしたいなー
        completion()
        //}

    }

    //並び順を更新
    func resetOrder() {
        //        for (index, app) in appList.enumerated() {
        //            //appの並びを更新
        //            var config = Realm.Configuration(schemaVersion: .schemaVersion)
        //            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        //            config.fileURL = url.appendingPathComponent("db.realm")
        //
        //            let realm = try! Realm(configuration: config)
        //            guard let app = realm.object(ofType: ApplicationData.self, forPrimaryKey: app.id) else {
        //                return
        //            }
        //            //arrayの方を更新
        //            app.order = index
        //            try! realm.write {
        //                app.order = index
        //                realm.add(app, update: .all)
        //            }
        //        }
    }

    //delete
    func deleteAppData(appList: [App], _ completion:() -> Void) {
        for app in appList {
            var config = Realm.Configuration(schemaVersion: .schemaVersion)
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
            config.fileURL = url.appendingPathComponent("db.realm")

            let realm = try! Realm(configuration: config)
            guard let obj = realm.object(ofType: App.self, forPrimaryKey: app.appStoreID) else {
                return
            }
            try! realm.write {
                realm.delete(obj)
            }
        }
        completion()
    }

    //save
    static func saveAppData(appList: [App], labelList: [Label], _ completion:() -> Void) {
        for labelData in labelList {
            var config = Realm.Configuration(schemaVersion: .schemaVersion)
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
            config.fileURL = url.appendingPathComponent("db.realm")

            let realm = try! Realm(configuration: config)
            //            for appData in appList {
            //                guard let app = realm.object(ofType: App.self, forPrimaryKey: appData.app?.id) else {
            //                    continue
            //                }
            //                guard let label = realm.object(ofType: Label.self, forPrimaryKey: labelData.id) else {
            //                    continue
            //                }
            //                let applicationData = realm.objects(ApplicationData.self).filter("label == %@ && app == %@", label, app)
            //                if applicationData.count > 0 {
            //                    //print("すでにラベルにあるよ")
            //                    continue
            //                }
            //                let id = UUID().uuidString
            //                let appCount = realm.objects(ApplicationData.self).filter("label == %@", label).count
            //                let object = ApplicationData(value: ["app": app,
            //                                                     "label": label,
            //                                                     "id": id,
            //                                                     "rate": 0,
            //                                                     "order": appCount,
            //                                                     "memo": ""])
            //                try! realm.write {
            //                    realm.add(object, update: .all)
            //                }
            //            }
        }
        completion()
    }

    func saveAppData(appList: [App], labelID: String, _ completion:() -> Void) {
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        guard let label = realm.object(ofType: Label.self, forPrimaryKey: labelID) else {
            return
        }
        //        for app in appList {
        //            let id = UUID().uuidString
        //            guard let appData = realm.object(ofType: App.self, forPrimaryKey: app.id) else {
        //                continue
        //            }
        //            let appCount = realm.objects(ApplicationData.self).filter("label == %@", label).count
        //            let object = ApplicationData(value: ["app": appData,
        //                                                 "label": label,
        //                                                 "id": id,
        //                                                 "rate": 0,
        //                                                 "order": appCount,
        //                                                 "memo": ""])
        //            try! realm.write {
        //                realm.add(object, update: .all)
        //            }
        //        }
        completion()
    }

    func deleteAppData(app: App, _ completion:() -> Void) {
        //ラベルについているAppのみを消すよ
        //        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        //        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        //        config.fileURL = url.appendingPathComponent("db.realm")
        //
        //        let realm = try! Realm(configuration: config)
        //        guard let obj = realm.object(ofType: ApplicationData.self, forPrimaryKey: app.id) else {
        //            return
        //        }
        //        try! realm.write {
        //            realm.delete(obj)
        //        }
        completion()
    }

    func deleteAppAllData(app: App, _ completion:() -> Void) {
        //        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        //        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        //        config.fileURL = url.appendingPathComponent("db.realm")
        //
        //        let realm = try! Realm(configuration: config)
        //        guard let appData = realm.object(ofType: App.self, forPrimaryKey: app.id) else {
        //            return
        //        }
        //        let objects = realm.objects(ApplicationData.self).filter("app == %@", appData)
        //        for obj in objects {
        //            try! realm.write {
        //                realm.delete(obj)
        //
        //            }
        //        }
        //        try! realm.write {
        //            realm.delete(appData)
        //        }
        //        completion()
    }
}
