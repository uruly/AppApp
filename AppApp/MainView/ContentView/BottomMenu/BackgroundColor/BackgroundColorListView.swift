//
//  BackgroundColorListView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class BackgroundColorListView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,collectionViewLayout: layout)
    }
    
    convenience init(frame: CGRect){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:50,height:50)
        layout.sectionInset = UIEdgeInsetsMake(15,15,15,15)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.init(frame: frame, collectionViewLayout: layout)
        
        self.register(UINib(nibName:"BackgroundColorViewCell",bundle:nil), forCellWithReuseIdentifier: "backColorSet")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        
    }

}

extension BackgroundColorListView: UICollectionViewDelegate {
    
}

extension BackgroundColorListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "backColorSet", for: indexPath)
        cell.contentView.backgroundColor = UIColor.mainBlue()
        return cell
    }
    

}
