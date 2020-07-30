//
//  Constants.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/02/25.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

extension String {

    static let appleID = "1319908151"
    static let groupID = "group.xyz.uruly.appapp"
    static let resolution = "@" + String(Int(UIScreen.main.scale)) + "x"
}

extension UInt64 {

    static let schemaVersion: UInt64 = 6
}

// MARK: - UserDefaults Keys

extension String {

    static let homeAppListModeIsList = "homeAppListModeIsList"
}
