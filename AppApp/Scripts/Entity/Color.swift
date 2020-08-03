//
//  Color.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

struct ColorPack: Codable {

    let title: String
    let colors: [Color]

    enum Codingkeys: String, CodingKey {
        case title
        case colors
    }
}

struct Color: Codable, Equatable {

    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }

    init(uiColor: UIColor) {
        let rgba = uiColor.rgba
        self.red = rgba.red
        self.green = rgba.green
        self.blue = rgba.blue
    }
}

extension Color {

    var uiColor: UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
