//
//  AppCollectionView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol AppCollectionViewDelegate{
    var baseVC:BaseViewController { get }
}

class AppCollectionView: UICollectionView {
    
    var itemSize:CGSize = CGSize(width:50.0,height:50.0)
    var appDelegate:AppCollectionViewDelegate! {
        didSet{
            appData = AppData(label:appDelegate.baseVC.appLabel)
        }
    }
    var appData:AppData! {
        didSet {
            self.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName:"AppCollectionViewCell",bundle:nil), forCellWithReuseIdentifier: "imageCollection")
        self.backgroundColor = UIColor.white
    }
    
    convenience init(frame:CGRect){
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 15.0
        layout.sectionInset = UIEdgeInsetsMake(margin,margin,margin,margin)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.itemSize = CGSize(width:50.0,height:50.0)
        self.init(frame:frame,collectionViewLayout:layout)
    }
    
    override func reloadData(){
        if appData != nil {
            super.reloadData()
        }
    }
}

extension AppCollectionView:UICollectionViewDelegate {
    
}

extension AppCollectionView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"imageCollection",for:indexPath) as! AppCollectionViewCell
        if appData == nil {
            return cell
        }
        cell.imageView.image = nil
        if let imageData = appData.appList[indexPath.row].app.image {
            cell.imageView.image = UIImage(data:imageData)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appData.appList.count
    }
}

extension AppCollectionView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}

extension AppCollectionView:IconSizeChangerDelegate{
    @objc func sliderValueChanged(sender: UISlider) {
        print("ここで受け取り！\(sender.value)")
        //collectionViewのitemSizeを変える
        self.itemSize = CGSize(width:CGFloat(sender.value),height:CGFloat(sender.value))
        self.collectionViewLayout.invalidateLayout()
    }
}
