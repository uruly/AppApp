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
        }
    }

    let label: Label

    private var mode: ToolbarMode = .collect

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

        view.backgroundColor = mode == .collect ? label.uiColor : .white
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
        if mode == .collect {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.appListCollectionViewCell, for: indexPath)!

            cell.configure(app: label.apps[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.appInfoListCollectionViewCell, for: indexPath)!
            //            cell.imageView.image = nil
            //            if let imageData = appData.appList[indexPath.row].app?.image {
            //                cell.imageView.image = UIImage(data: imageData)
            //            }
            //            cell.nameLabel.text = appData.appList[indexPath.row].app?.name
            //            cell.developerLabel.text = appData.appList[indexPath.row].app?.developer
            //
            //            //チェックマーク
            //            cell.checkImageView.isHidden = true
            //            cell.imageView.alpha = 1.0
            //            //編集中かどうか
            //            if AppCollectionView.isWhileEditing {
            //                if checkArray.contains(where: {$0.id == appData.appList[indexPath.row].id}) {
            //                    cell.checkImageView.isHidden = false
            //                    cell.imageView.alpha = 0.5
            //                }
            //            }

            return cell
        }
    }

}
