//
//  ColorPickerViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/08/03.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class ColorPickerViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(R.nib.colorSetCollectionViewCell)
        }
    }

    var colorSet: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(onTapSaveButton))
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(onTapCancelButton))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }

    @objc func onTapSaveButton() {
        // notification
    }

    @objc func onTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension ColorPickerViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSources

extension ColorPickerViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorSet.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.colorSetCollectionViewCell, for: indexPath)!
        cell.contentView.backgroundColor = colorSet[indexPath.row]
        return cell
    }
}
