//
//  AppsViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/28.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class AppsViewController: UIViewController {

    @IBOutlet private(set) weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(R.nib.appInfoListCollectionViewCell)
            collectionView.register(R.nib.appListCollectionViewCell)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = mode == .collect ? label.uiColor : .white
        }
    }

    let label: Label

    private var mode: ToolbarMode = UserDefaults.standard.bool(forKey: .homeAppListModeIsList) ? .list : .collect {
        didSet {
            collectionView.reloadData()
        }
    }
    private var itemSize: CGSize = CGSize(width: 100, height: 100) {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    // MARK: - Initializer

    init(label: Label) {
        self.label = label
        super.init(nibName: R.nib.appsViewController.name, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = label.uiColor

        NotificationCenter.default.addObserver(self, selector: #selector(changeMode(notification:)), name: .toolbarMode, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeIconSize(notification:)), name: .iconSize, object: nil)
    }

    @objc func changeMode(notification: Notification) {
        guard let mode = notification.object as? ToolbarMode else {
            fatalError("ToolbarMode じゃないよ")
        }
        self.mode = mode
        UserDefaults.standard.set(mode == .list, forKey: .homeAppListModeIsList)
    }

    @objc func changeIconSize(notification: Notification) {
        guard let value = notification.object as? Float else {
            fatalError("Slider value じゃないよ")
        }
        itemSize = CGSize(width: CGFloat(value), height: CGFloat(value))
    }
}

// MARK: - UICollectionViewDelegate

extension AppsViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension AppsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return label.apps.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch mode {
        case .collect:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.appListCollectionViewCell, for: indexPath)!

            cell.configure(app: label.apps[indexPath.row])
            return cell
        case .list:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.appInfoListCollectionViewCell, for: indexPath)!
            cell.configure(app: label.apps[indexPath.row])

            return cell
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension AppsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch mode {
        case .collect:
            return itemSize
        case .list:
            return CGSize(width: view.frame.width - 30, height: 125)
        }
    }
}
