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
        
        self.backgroundColor = UIColor.white
        self.register(CustomBackgroundCell.self, forCellWithReuseIdentifier: "customBackView")
        self.register(UploadViewCell.self, forCellWithReuseIdentifier: "uploadView")
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
        if indexPath.row == 0 {
            let cell:CustomBackgroundCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customBackView", for: indexPath) as! CustomBackgroundCell
            if cell.view.backColorList != nil {
                cell.view.backColorList.reloadData()
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uploadView", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageDelegate.movePage(count:indexPath.row)
    }
    
}

class CustomBackgroundCell:UICollectionViewCell {
    var view:CustomBackgroundView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = CustomBackgroundView(frame:self.contentView.frame)
        self.contentView.addSubview(view)
    }
}

class UploadViewCell:UICollectionViewCell {
    var view:UploadView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = UploadView(frame:self.contentView.frame)
        self.contentView.addSubview(view)
    }
}
