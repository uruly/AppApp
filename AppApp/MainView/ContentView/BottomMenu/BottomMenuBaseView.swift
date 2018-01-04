//
//  BottomMenuBaseView.swift
//  BottomMenu
//
//  Created by 久保　玲於奈 on 2018/01/04.
//  Copyright © 2018年 久保　玲於奈. All rights reserved.
//

import UIKit

@objc protocol BottomMenuPageControlDelegate {
    func movePage(count:Int)
}

class BottomMenuBaseView: UICollectionView {
    
    var pageDelegate:BottomMenuPageControlDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init(frame:CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:frame.width,height:frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.init(frame: frame, collectionViewLayout: layout)
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "bottomView")
        self.delegate = self
        self.dataSource = self
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    //物がないところはスルーして欲しい
}

extension BottomMenuBaseView: UICollectionViewDelegate {
}

extension BottomMenuBaseView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomView", for: indexPath)
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor.brown
        }else {
            cell.contentView.backgroundColor = UIColor.red
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageDelegate.movePage(count:indexPath.row)
    }
    
}
