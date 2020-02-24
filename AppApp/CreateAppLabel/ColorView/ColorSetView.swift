//
//  ColorSetView.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class ColorSetView: UICollectionView {

    var colorSet: [UIColor] = []
    weak var colorDelegate: ColorDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.register(UINib(nibName: "ColorSetViewCell", bundle: nil), forCellWithReuseIdentifier: "color")
    }

}

extension ColorSetView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorSetViewCell
        cell.isSelected = true

        //print(colorDelegate)
        if colorDelegate != nil {
            colorDelegate.setColor(color: colorSet[indexPath.row])
        }
    }

}
extension ColorSetView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
    }
}

extension ColorSetView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorSet.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color", for: indexPath) as! ColorSetViewCell
        cell.contentView.backgroundColor = colorSet[indexPath.row]
        return cell
    }

}
