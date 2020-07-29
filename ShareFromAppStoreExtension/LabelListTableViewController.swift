//
//  LabelListTableViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol LabelListTableViewControllerDelegate {
    var shareVC: ShareViewController { get }
}

class LabelListTableViewController: UITableViewController {

    var labels: [Label] = []

    weak var delegate: LabelListTableViewControllerDelegate!
    static var isUnwindCreate = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "labelList")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readLabelData()
    }

    func readLabelData() {
        labels = Label.getAll()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {   //新しく作る
            return 1
        }
        return labels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelList", for: indexPath)

        if indexPath.section == 1 {
            cell.textLabel?.text = "新しいラベルを作成"
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = labels[indexPath.row].name
            //            if self.delegate.shareVC.labelList.contains(where: {$0.id == labels[indexPath.row].id}) {
            //                cell.accessoryType = .checkmark
            //            } else {
            //                cell.accessoryType = .none
            //            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let createLabelVC = CreateLabelViewController(style: .grouped)
            self.navigationController?.pushViewController(createLabelVC, animated: true)
            return
        }

        let cell = tableView.cellForRow(at: indexPath)

        //        if self.delegate.shareVC.labelList.contains(where: {$0.id == list[indexPath.row].id}) {
        //            //外す
        //            cell?.accessoryType = .none
        //            let index = self.delegate.shareVC.labelList.findIndex {$0.id == list[indexPath.row].id}
        //            if index.count > 0 {
        //                self.delegate.shareVC.labelList.remove(at: index[0])
        //            }
        //
        //        } else {
        //            //つける
        //            cell?.accessoryType = .checkmark
        //            self.delegate.shareVC.labelList.append(list[indexPath.row])
        //        }

        cell?.isSelected = false
    }
}

extension Array where Element: Hashable {

    func unique() -> [Element] {
        var elements = [Element]()
        for value in self {
            elements += !elements.contains(value) ? [value] : []
        }
        return elements
    }

    mutating func uniqueInPlace() {
        self = self.unique()
    }

}

extension Array {
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        var indexArray: [Int] = []
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
}
