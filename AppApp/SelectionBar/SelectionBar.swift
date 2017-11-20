//
//  SelectionBar.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class SelectionBar: UICollectionView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName:"SelectionBarCell",bundle:nil), forCellWithReuseIdentifier: "selection")
        self.backgroundColor = UIColor.backgroundGray()
        self.showsHorizontalScrollIndicator = false
    }
    
    convenience init(frame:CGRect){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(15,0,0,0)
        layout.estimatedItemSize = CGSize(width:100,height:50)
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)
    }
}

extension SelectionBar: UICollectionViewDelegate {
    
}

extension SelectionBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        //＋ボタン
        if section == 1 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selection", for: indexPath) as! SelectionBarCell
        if indexPath.section == 0 {
            
        }
        if indexPath.section == 1 {
            cell.label.text = "＋"
            cell.contentView.backgroundColor = UIColor.plusBackground()
            cell.label.textColor = UIColor.white
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}
