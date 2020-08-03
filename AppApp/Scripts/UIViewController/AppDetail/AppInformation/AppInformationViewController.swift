//
//  AppInformationViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppInformationViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(R.nib.appInformationTableViewCell)
        }
    }
    @IBOutlet private weak var tableViewConstraintHeight: NSLayoutConstraint!

    let app: App

    enum AppInformation {
        case name
        case developer

        var title: String {
            switch self {
            case .name:
                return "App名"
            case .developer:
                return "開発者"
            }
        }
    }
    let information: [AppInformation] = [.name, .developer]

    // MARK: - Initializer

    init(app: App) {
        self.app = app
        super.init(nibName: R.nib.appInformationViewController.name, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.layoutIfNeeded()
        tableViewConstraintHeight.constant = tableView.contentSize.height
        view.frame.size.height = tableView.contentSize.height
    }
}

// MARK: - UITableViewDelegate

extension AppInformationViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension AppInformationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.appInformationTableViewCell, for: indexPath)!
        let info = information[indexPath.row]
        let data: String
        switch info {
        case .name:
            data = app.name
        case .developer:
            data = app.developer
        }
        cell.configure(title: info.title, data: data)
        return cell
    }
}
