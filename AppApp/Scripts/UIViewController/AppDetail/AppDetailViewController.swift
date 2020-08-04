//
//  AppDetailViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit
import StoreKit

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
        readDataIfNeeded()
        setupChildren()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }

    private func setupChildren() {
        let infoViewController = AppInformationViewController(app: app)
        addChild(infoViewController)
        stackView.addArrangedSubview(infoViewController.view)
        infoViewController.didMove(toParent: self)
    }

    private func readDataIfNeeded() {
        guard app.name == "" || app.developer == "" else { return }
        AppRequest.shared.fetchApp(app: app)
    }

    @IBAction func onTapAppStoreButton(_ sender: UIButton) {
        let viewController = SKStoreProductViewController()
        viewController.delegate = self
        let id = app.appStoreID.filter({ $0.isNumber })
        present(viewController, animated: true) {
            viewController.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: id]) { (_, error) in
                if error != nil {
                    viewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - SKStoreProductViewControllerDelegate

extension AppDetailViewController: SKStoreProductViewControllerDelegate {

    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }

}
