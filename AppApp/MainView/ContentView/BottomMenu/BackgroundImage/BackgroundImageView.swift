//
//  BackgroundImageView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class BackgroundImageView: UICollectionView {
    
    var imageList:[UIImage] = []
    var currentIndexPath:IndexPath = IndexPath(row:0,section:0)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,collectionViewLayout: layout)
    }
    
    convenience init(frame: CGRect){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:50,height:50)
        layout.sectionInset = UIEdgeInsetsMake(15,15,15,0)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)
        
        self.register(UINib(nibName:"BackgroundImageCell",bundle:nil), forCellWithReuseIdentifier: "backImageSet")
        self.register(BackgroundPlusCell.self, forCellWithReuseIdentifier: "plus")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        
    }
    
    func changeBackgroundImage() {
        if let basePageVC:BasePageViewController = findViewController() {
            print("basepageVCあるよ")
            if let baseVC:BaseViewController = basePageVC.viewControllers?.first as? BaseViewController {
            }
        }
    }
}

extension BackgroundImageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
//            if currentIndexPath == indexPath {
//                return
//            }
            if let cell:BackgroundColorViewCell = collectionView.cellForItem(at: indexPath) as? BackgroundColorViewCell {
                cell.checkImageView.isHidden = false
                //currentColor = colorList[indexPath.row]
            }
            if let previousCell:BackgroundColorViewCell = collectionView.cellForItem(at: currentIndexPath) as? BackgroundColorViewCell{
                previousCell.checkImageView.isHidden = true
                currentIndexPath = indexPath
            }
            changeBackgroundImage()
        }else {
            //カラーピッカーを表示
        }
    }
}

extension BackgroundImageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return imageList.count > 5 ? 5 : imageList.count
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell:BackgroundImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "backImageSet", for: indexPath) as! BackgroundImageCell
            //cell.contentView.backgroundColor = colorList[indexPath.row]
            if currentIndexPath == indexPath {
                cell.checkImageView.isHidden = false
            }else {
                cell.checkImageView.isHidden = true
            }
            return cell
        }else {
            let cell:BackgroundPlusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "plus", for: indexPath) as! BackgroundPlusCell
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
}
