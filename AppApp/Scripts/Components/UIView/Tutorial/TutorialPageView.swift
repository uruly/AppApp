//
//  TutorialPageView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol TutorialPageControlDelegate {
    func movePage(count: Int)
    var tutorialVC: TutorialViewController { get }
}

class TutorialPageView: UICollectionView {

    weak var pageDelegate: TutorialPageControlDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName: "WelcomeViewCell", bundle: nil), forCellWithReuseIdentifier: "welcome")
        self.register(UINib(nibName: "HowToViewCell", bundle: nil), forCellWithReuseIdentifier: "howTo")
        self.register(UINib(nibName: "StartViewCell", bundle: nil), forCellWithReuseIdentifier: "start")
    }

    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        self.init(frame: frame, collectionViewLayout: layout)
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.mainBlue()
    }

}

extension TutorialPageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
    }
}

extension TutorialPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //ページ数
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "welcome", for: indexPath) as! WelcomeViewCell
            return cell
        } else if indexPath.row < 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "howTo", for: indexPath) as! HowToViewCell
            for subview in cell.howToView.subviews {
                subview.removeFromSuperview()
            }
            cell.howToView.setup(index: indexPath.row - 1)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "start", for: indexPath) as! StartViewCell
            cell.startView.tutorialVC = pageDelegate.tutorialVC
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageDelegate.movePage(count: indexPath.row)
    }
}
