//
//  BackgroundColorListView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit


class BackgroundColorListView: UICollectionView {

    var colorList:[UIColor] = [.white]
    var labelColor:UIColor? {
        get {
            return AppLabel.currentColor
        }
    }
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
        
        self.register(UINib(nibName:"BackgroundColorViewCell",bundle:nil), forCellWithReuseIdentifier: "backColorSet")
        self.register(BackgroundPlusCell.self, forCellWithReuseIdentifier: "plus")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        
        //真っ白とラベルカラーを入れておく
        if labelColor != nil {
            colorList.append(labelColor!)
        }
    }

    override func reloadData() {
        if self.colorList.count >= 2 && labelColor != nil{
            //上書き
            self.colorList[1] = labelColor!
        }else if labelColor != nil{
            self.colorList.append(labelColor!)
        }
        super.reloadData()
    }
}

extension BackgroundColorListView: UICollectionViewDelegate {
    
}

extension BackgroundColorListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return colorList.count > 5 ? 5 : colorList.count
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "backColorSet", for: indexPath)
            cell.contentView.backgroundColor = colorList[indexPath.row]
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

