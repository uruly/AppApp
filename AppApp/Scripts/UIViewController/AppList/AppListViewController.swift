//
//  AppListViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppListViewController: UIViewController {

    var apps: [App] = [] {
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

        if let allApps = Label.getAllLabel()?.apps {
            self.apps = Array(allApps)
        }
    }

}

// MARK: - UITableViewDelegate

extension AppListViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension AppListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppListTableViewCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.appListTableViewCell, for: indexPath)!
        cell.configure(app: apps[indexPath.row])
        return cell
    }

}
