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
    static let allLabel = "ALLLABEL"
}

extension UInt64 {

    static let schemaVersion: UInt64 = 6
}

// MARK: - UserDefaults Keys

extension String {

    static let homeAppListModeIsList = "homeAppListModeIsList"
    static let homeAppListIconSize = "homeAppListIconSize"
}

extension Notification.Name {

    static let toolbarMode = Notification.Name("toolbarMode")
    static let iconSize = Notification.Name("iconSize")
    static let isAppEditing = Notification.Name("isAppEditing")
}
