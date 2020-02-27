//
//  BackgroundColorListView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit
@objc protocol BottomViewDelegate {
    func closeMenu()
}

class BackgroundColorListView: UICollectionView {

    var colorList: [UIColor] = [.white]
    var labelColor: UIColor? {
        return AppLabel.currentColor
    }
    static var isDefaultColor: Bool = true
    var currentColor: UIColor!
    var currentIndexPath: IndexPath!
    weak var bottomDelegate: BottomViewDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 0)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)

        register(R.nib.backgroundColorCollectionViewCell)
        register(R.nib.backgroundPlusCollectionViewCell)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white

        //真っ白とラベルカラーを入れておく
        if labelColor != nil {
            colorList.append(labelColor!)
        }
        currentIndexPath = IndexPath(row: 0, section: 0)
    }

    override func reloadData() {
        //色を変更
        if self.colorList.count >= 2 && labelColor != nil {
            //上書き
            self.colorList[1] = labelColor!

        } else if labelColor != nil {
            self.colorList.append(labelColor!)
        }
        if labelColor != nil, AppLabel.currentBackgroundColor == nil {
            if UserDefaults.standard.bool(forKey: "isList") {
                currentColor = labelColor!
                //AppLabel.currentBackgroundColor = currentColor
                currentIndexPath = IndexPath(row: 1, section: 0)
            } else {
                currentColor = UIColor.white
                //AppLabel.currentBackgroundColor = currentColor
                currentIndexPath = IndexPath(row: 0, section: 0)
            }
        } else {
            currentColor = AppLabel.currentBackgroundColor
            let index = colorList.findIndex(includeElement: { (color) -> Bool in
                return color == currentColor
            })
            if index.count > 0 {
                currentIndexPath = IndexPath(row: index[0], section: 0)
            }

        }
        //print(labelColor)
        super.reloadData()
    }

    func changeBackgroundColor() {
        //whiteとラベル色を選んだらこれをfalseにしたい
        //BackgroundColorListView.isDefaultColor = false
        if let basePageVC: BasePageViewController = findViewController() {
            //print("basepageVCあるよ")
            if let baseVC: BaseViewController = basePageVC.viewControllers?.first as? BaseViewController {
                AppLabel.currentBackgroundColor = currentColor
                baseVC.backgroundColor = currentColor
            }
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }

}

extension BackgroundColorListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if currentIndexPath == indexPath {
                return
            }
            if let cell: BackgroundColorCollectionViewCell = collectionView.cellForItem(at: indexPath) as? BackgroundColorCollectionViewCell {
                cell.checkImageView.isHidden = false
                currentColor = colorList[indexPath.row]
            }
            if let previousCell: BackgroundColorCollectionViewCell = collectionView.cellForItem(at: currentIndexPath) as? BackgroundColorCollectionViewCell {
                previousCell.checkImageView.isHidden = true
                currentIndexPath = indexPath
            }
            changeBackgroundColor()
        } else {
            //カラーピッカーを表示
        }
    }
}

extension BackgroundColorListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return colorList.count > 5 ? 5 : colorList.count
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.backgroundColorCollectionViewCell, for: indexPath)!
            cell.contentView.backgroundColor = colorList[indexPath.row]
            if currentIndexPath == indexPath {
                cell.checkImageView.isHidden = false
            } else {
                cell.checkImageView.isHidden = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.backgroundPlusCollectionViewCell, for: indexPath)!
            return cell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return 2      //plusボタンをつけるかどうか
        return 1
    }

}

//extension BackgroundColorListView:ColorListDelegate {
//    func labelChanged(color: UIColor) {
//        if self.colorList.count > 2 {
//            //上書き
//            self.colorList[1] = color
//        }else {
//            self.colorList.append(color)
//        }
//    }
//}
