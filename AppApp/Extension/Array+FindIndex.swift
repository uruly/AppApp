//
//  Array+FindIndex.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/24.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

extension Array {
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        var indexArray:[Int] = []
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
    
    func findAll(includeElement: (Element) -> Bool) -> [(Int, Element)] {
        let seq = zip(0..<self.count, self)
        return seq.filter() { includeElement($0.1) }
    }
}
