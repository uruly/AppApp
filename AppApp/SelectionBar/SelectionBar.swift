//
//  SelectionBar.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class SelectionBar: UICollectionView {
    
    var pageVC:BasePageViewController!
    
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
    
    convenience init(frame:CGRect,pageVC:BasePageViewController){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(15,0,0,0)
        layout.estimatedItemSize = CGSize(width:100,height:50)
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)
        self.pageVC = pageVC
    }
}

extension SelectionBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //＋ボタンを押しているはず
        if indexPath.section == 1 {
            //ここでpageVC上のラベル追加関数を呼び出す
            pageVC.createAppLabel()
        }
    }
}

extension SelectionBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return pageVC.appLabel.array.count
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
            cell.label.text = pageVC.appLabel.array[indexPath.row].name
            cell.contentView.backgroundColor = pageVC.appLabel.array[indexPath.row].color
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
