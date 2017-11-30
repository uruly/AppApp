//
//  ColorPageView.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol ColorPageControlDelegate {
    func movePage(count:Int)
}

enum ColorMode {
    case set
    case custom
}

class ColorPageView: UICollectionView {

    var colors:[UIColor] = [UIColor.purple,UIColor.blue,UIColor.brown,UIColor.yellow,UIColor.red]
    var colorDelegate:ColorPageControlDelegate!
    var colorMode:ColorMode = .set {
        didSet{
            self.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(UINib(nibName:"ColorBaseCell",bundle:nil), forCellWithReuseIdentifier: "base")
        self.register(UINib(nibName:"RGBSliderCell",bundle:nil), forCellWithReuseIdentifier: "customBase")
        self.delegate = self
        self.dataSource = self
    }
    
    convenience init(frame: CGRect){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:frame.width,height:frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.init(frame: frame, collectionViewLayout: layout)
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.appStoreBlue()
    }
    
}

extension ColorPageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
    }
}

extension ColorPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if colorMode == .set {  //ページ数
            return colors.count
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if colorMode == .set {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "base", for: indexPath) as! ColorBaseCell
            //cell.backgroundColor = colors[indexPath.row]
            cell.colorSetView.colorSet = [colors[indexPath.row]]
            cell.colorSetView.reloadData()
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customBase", for: indexPath) as! RGBSliderCell
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        colorDelegate.movePage(count:indexPath.row)
    }
}
