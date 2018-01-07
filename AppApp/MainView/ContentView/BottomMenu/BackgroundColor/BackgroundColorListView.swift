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
        layout.sectionInset = UIEdgeInsetsMake(15,15,15,15)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.init(frame: frame, collectionViewLayout: layout)
        
        self.register(UINib(nibName:"BackgroundColorViewCell",bundle:nil), forCellWithReuseIdentifier: "backColorSet")
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
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "backColorSet", for: indexPath)
        cell.contentView.backgroundColor = colorList[indexPath.row]
        return cell
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

