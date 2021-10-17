//
//  UICollectionView+BatchUpdates.swift
//  OKAIMO
//
//  Created by Reona Kubo on 2019/06/14.
//  Copyright © 2019 Reona Kubo. All rights reserved.
//

import UIKit

struct BatchUpdates {

    struct Cells {
        let deleted: [Int]
        let inserted: [Int]
        let moved: [(Int, Int)]
        let reloaded: [Int] = []
    }

    let items: Cells
    let sections: Cells?

    init(items: Cells, sections: Cells?) {
        self.items = items
        self.sections = sections
    }

    static func compare<T: Equatable>(oldValues: [T], newValues: [T]) -> Cells {
        var deleted = [Int]()
        var moved = [(Int, Int)]()

        var remainingNewValues = newValues
            .enumerated()
            .map { (element: $0.element, offset: $0.offset, alreadyFound: false) }

        outer: for oldValue in oldValues.enumerated() {
            for newValue in remainingNewValues {
                if oldValue.element == newValue.element && !newValue.alreadyFound {
                    if oldValue.offset != newValue.offset {
                        moved.append((oldValue.offset, newValue.offset))
                    }

                    remainingNewValues[newValue.offset].alreadyFound = true

                    continue outer
                }
            }

            deleted.append(oldValue.offset)
        }

        let inserted = remainingNewValues
            .filter { !$0.alreadyFound }
            .map { $0.offset }

        return Cells(deleted: deleted, inserted: inserted, moved: moved)
    }

    static func setup<T: Equatable, U: Equatable>(oldItems: [T], newItems: [T], oldSection: [U], newSection: [U]) -> BatchUpdates {
        let items = compare(oldValues: oldItems, newValues: newItems)
        let sections = compare(oldValues: oldSection, newValues: newSection)
        return BatchUpdates.init(items: items, sections: sections)
    }

    static func setup<T: Equatable>(oldItems: [T], newItems: [T]) -> BatchUpdates {
        let items = compare(oldValues: oldItems, newValues: newItems)
        return BatchUpdates.init(items: items, sections: nil)
    }

}

extension UICollectionView {

    func reloadData(with batchUpdates: BatchUpdates, target section: Int = 0) {
        performBatchUpdates({
            // sectionをアップデート
            if let sections = batchUpdates.sections {
                self.deleteSections(IndexSet(sections.deleted))
                self.reloadSections(IndexSet(sections.reloaded))
                self.insertSections(IndexSet(sections.inserted))
            }

            // itemをアップデート
            self.deleteItems(at: batchUpdates.items.deleted.map {
                                IndexPath(row: $0, section: section) })
            self.reloadItems(at: batchUpdates.items.reloaded.map {
                                IndexPath(row: $0, section: section) })
            self.insertItems(at: batchUpdates.items.inserted.map {
                                IndexPath(row: $0, section: section) })

            for movedRows in batchUpdates.items.moved {
                self.moveItem(
                    at: IndexPath(row: movedRows.0, section: section),
                    to: IndexPath(row: movedRows.1, section: section)
                )
            }
        })
    }
}

extension UITableView {

    func reloadData(with batchUpdates: BatchUpdates, target section: Int = 0) {
        performBatchUpdates({
            // sectionをアップデート
            if let sections = batchUpdates.sections {
                self.deleteSections(IndexSet(sections.deleted), with: .right)
                self.reloadSections(IndexSet(sections.reloaded), with: .fade)
                self.insertSections(IndexSet(sections.inserted), with: .left)
            }

            // itemをアップデート
            self.deleteRows(at: batchUpdates.items.deleted.map {
                                IndexPath(row: $0, section: section) }, with: .right)
            self.reloadRows(at: batchUpdates.items.reloaded.map {
                                IndexPath(row: $0, section: section) }, with: .fade)
            self.insertRows(at: batchUpdates.items.inserted.map {
                                IndexPath(row: $0, section: section) }, with: .left)
        })
    }
}
