//
//  AppsViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/28.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppsViewController: UIViewController {

    let label: Label

    // MARK: - Initializer

    init(label: Label) {
        self.label = label
        super.init(nibName: R.nib.appsViewController.name, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
