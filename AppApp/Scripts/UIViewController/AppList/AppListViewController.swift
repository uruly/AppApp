//
//  AppListViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppListViewController: UIViewController {

    var selectedApps: [App] = [] {
        didSet {
            NotificationCenter.default.post(name: .addAppsToLabel, object: selectedApps, userInfo: nil)
        }
    }

    private var apps: [App] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(R.nib.appListTableViewCell)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Appを追加"
        if let allApps = Label.getAllLabel()?.apps {
            self.apps = Array(allApps)
        }
    }

}

// MARK: - UITableViewDelegate

extension AppListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell: AppListTableViewCell = tableView.cellForRow(at: indexPath) as? AppListTableViewCell, let app = cell.app else { return }
        selectedApps.append(app)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell: AppListTableViewCell = tableView.cellForRow(at: indexPath) as? AppListTableViewCell, let app = cell.app else { return }
        if let index = selectedApps.firstIndex(where: {$0 == app}) {
            selectedApps.remove(at: index)
        }
    }
}

// MARK: - UITableViewDataSource

extension AppListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppListTableViewCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.appListTableViewCell, for: indexPath)!
        cell.configure(app: apps[indexPath.row])
        cell.isSelected = selectedApps.contains(where: {$0 == apps[indexPath.row]})
        if cell.isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }

        return cell
    }

}
