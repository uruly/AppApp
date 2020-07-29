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

final class LabelListTableViewController: UITableViewController {

    private let reuseIdentifier = "labelList"

    private var labels: [Label] = []

    weak var delegate: LabelListTableViewControllerDelegate?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsMultipleSelection = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        readLabel { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - TableView DataSource

extension LabelListTableViewController {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = .systemBackground
        cell.accessoryView?.backgroundColor = .systemBackground

        if indexPath.section == 1 {
            cell.textLabel?.text = "新しいラベルを作成"
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = labels[indexPath.row].name
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let createLabelVC = CreateLabelViewController(style: .grouped)
            navigationController?.pushViewController(createLabelVC, animated: true)
            return
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        cell?.isHighlighted = false
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
}

// MARK: - Realm

extension LabelListTableViewController {

    private func readLabel(_ completion: (() -> Void)) {
        labels = Label.getAll()
        defer { completion() }
        guard labels.isEmpty else { return }
        // ALL labelを追加する
        guard let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor.blue, requiringSecureCoding: false) else {
            fatalError("Color Archived Error!!")
        }
        let allLabel = Label(id: UUID.init().uuidString, name: "ALL", color: colorData, order: 0, explain: "すべてのApp")
        labels = [allLabel]
        do {
            try Label.add(allLabel)
        } catch {
            print("Error")
        }
    }
}
