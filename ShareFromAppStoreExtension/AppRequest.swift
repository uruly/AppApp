//
//  AppRequest.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/30.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import Foundation

struct AppRequest {

    static let shared = AppRequest()

    func fetchApp(app: App) {
        let id = app.appStoreID.filter({ $0.isNumber })
        // TODO: country のローカライズ
        let apiURL = URL(string: "https://itunes.apple.com/lookup?id=\(id)&country=JP")!

        do {
            let data = try Data(contentsOf: apiURL)
            guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else { return }
            guard let result = (json["results"] as? [Any])?.first as? [String: Any] else { return }
            if let name = result["trackName"] as? String {
                let realm = DatabaseManager.shared.realm
                try? realm.write {
                    app.name = name
                }
            }
            if let developer = result["artistName"] as? String {
                let realm = DatabaseManager.shared.realm
                try? realm.write {
                    app.developer = developer
                }
            }
        } catch let erro as NSError {
            print(erro.description)
        }
    }
}
