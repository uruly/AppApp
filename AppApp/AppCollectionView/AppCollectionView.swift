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
    var lastContentOffsetY:CGFloat = 0
    var appDelegate:AppCollectionViewDelegate! {
        didSet{
//            if appDelegate.baseVC.appLabel.name == "ALL" {
//                appData = AppData(allLabel:appDelegate.baseVC.appLabel)
//            }else {
//                appData = AppData(label:appDelegate.baseVC.appLabel)
//            }
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
        
        //長押しで
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(sender:)))
        longPress.allowableMovement = 10
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
    }
    
    convenience init(frame:CGRect){
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 15.0
        layout.sectionInset = UIEdgeInsetsMake(margin,margin,margin + 49,margin)
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
    
    @objc func cellLongPressed(sender:UILongPressGestureRecognizer){
        switch(sender.state) {
            
        case .began:
            guard let selectedIndexPath = self.indexPathForItem(at: sender.location(in:self)) else {
                break
            }
            self.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            self.updateInteractiveMovementTargetPosition(sender.location(in: sender.view!))
            
        case .ended:
            self.endInteractiveMovement()
            
        default:
            self.cancelInteractiveMovement()
        }
    }
}

extension AppCollectionView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //画面遷移をする
        self.appDelegate.baseVC.toDetailViewController(appData:appData)
    }
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
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempNumber = appData.appList.remove(at: sourceIndexPath.item)
        appData.appList.insert(tempNumber, at: destinationIndexPath.item)
        //appDataのorderを更新
        appData.resetOrder()
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

extension AppCollectionView:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffsetY = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("offsetY\(scrollView.contentOffset.y)")
        let maxY = self.appDelegate.baseVC.view.frame.maxY
        let middleHeight = self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.height / 2
        let diffX = fabs(lastContentOffsetY - scrollView.contentOffset.y)
        if scrollView.contentOffset.y >= 0 {
            if scrollView.contentOffset.y > lastContentOffsetY {
                print("非表示")
                if self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.minY < maxY {
                    if self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.minY + diffX < 0 {
                        self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y = maxY + middleHeight
                    }else {
                        print("ここよばれてり")
                        self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y += diffX
                    }
                }
            }else {
                print("表示")
                if self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.maxY > maxY {
                    //上にあげすぎない
                    if self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.maxY - diffX < maxY {
                        self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y = maxY - middleHeight
                    }else {
                        self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y -= diffX
                    }
                }
            }
        }
        lastContentOffsetY = scrollView.contentOffset.y
        //self.appDelegate.baseVC.basePageVC.iconSizeChanger.isHidden = true
    }
    
    
}
