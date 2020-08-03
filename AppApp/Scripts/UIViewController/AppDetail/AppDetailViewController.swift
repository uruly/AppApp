//
//  AppDetailViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppDetailViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!

    let app: App

    // MARK: - Initializer

    init(app: App) {
        self.app = app
        super.init(nibName: R.nib.appDetailViewController.name, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageData = app.image {
            imageView.image = UIImage(data: imageData)
        }
        setupChildren()
    }

    private func setupChildren() {
        let infoViewController = AppInformationTableViewController(nib: R.nib.appInformationTableViewController)
        addChild(infoViewController)
        stackView.addArrangedSubview(infoViewController.view)
        infoViewController.didMove(toParent: self)
    }

}
