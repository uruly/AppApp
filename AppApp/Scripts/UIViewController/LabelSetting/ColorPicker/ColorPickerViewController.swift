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

    var selectColor: Color

    private var colorPack: [ColorPack] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Initializer

    init(color: Color) {
        selectColor = color
        super.init(nibName: R.nib.colorPickerViewController.name, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(onTapSaveButton))
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(onTapCancelButton))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        readColorPack()
    }

    @objc func onTapSaveButton() {
        // notification
    }

    @objc func onTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }

    private func readColorPack() {
        do {
            let jsonString = try String(contentsOf: R.file.colorDataJson()!, encoding: .utf8)
            guard let data = jsonString.data(using: .utf8) else { return }
            let colorPack = try JSONDecoder().decode([ColorPack].self, from: data)
            self.colorPack = colorPack
        } catch {
            print("json get error", error)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ColorPickerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorSetCollectionViewCell, let color = cell.color else { return }
        self.selectColor = color
    }
}

// MARK: - UICollectionViewDataSources

extension ColorPickerViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colorPack.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorPack[section].colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.colorSetCollectionViewCell, for: indexPath)!
        let color = colorPack[indexPath.section].colors[indexPath.row]
        cell.configure(color: color)
        if selectColor == color {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        return cell
    }
}
