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
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.appInformationTableViewCell, for: indexPath)!
        return cell
    }
}

