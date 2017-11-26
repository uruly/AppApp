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
    
    static var isWhileEditing = false
    var itemSize:CGSize = CGSize(width:50,height:50)
    var lastContentOffsetY:CGFloat = 0
    var maxSize:CGFloat = 160.0
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
    
    var checkArray:[ApplicationStruct] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName:"AppCollectionViewCell",bundle:nil), forCellWithReuseIdentifier: "imageCollection")
        self.register(UINib(nibName:"AppInfoCell",bundle:nil), forCellWithReuseIdentifier: "AppInfo")
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
        let iconSize = CGFloat(UserDefaults.standard.float(forKey:"IconSize"))
        if iconSize < 30 {
            layout.itemSize = CGSize(width:50.0,height:50.0)
            UserDefaults.standard.set(50.0, forKey: "IconSize")
        }else{
            layout.itemSize = CGSize(width:iconSize,height:iconSize)
        }
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
    
    func deleteAppData(){
        appData.deleteAppData(appList: checkArray){
            if checkArray.count > 0 {
                self.appData.readAppData(label: checkArray[0].label)
                self.appData.resetOrder()
                self.checkArray = []
                self.reloadData()
            }
        }
    }
}

extension AppCollectionView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppCollectionView.isWhileEditing {
            if itemSize.width < maxSize {
                let cell:AppCollectionViewCell = collectionView.cellForItem(at: indexPath) as! AppCollectionViewCell
                
                let id = appData.appList[indexPath.row].id
                let index = checkArray.findIndex(includeElement: {$0.id == id})
                if index.count > 0 {
                    self.checkArray.remove(at: index[0])
                    cell.checkImageView.isHidden = true
                    cell.imageView.alpha = 1.0
                }else {
                    self.checkArray.append(appData.appList[indexPath.row])
                    cell.checkImageView.isHidden = false
                    cell.imageView.alpha = 0.5
                }
            }
        }else{
            //画面遷移をする
            self.appDelegate.baseVC.toDetailViewController(appData:appData)
        }
    }
}

extension AppCollectionView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if itemSize.width < maxSize {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"imageCollection",for:indexPath) as! AppCollectionViewCell
            if appData == nil {
                return cell
            }
            cell.checkImageView.isHidden = true
            cell.imageView.alpha = 1.0
            //編集中かどうか
            if AppCollectionView.isWhileEditing {
                if checkArray.contains(where: {$0.id == appData.appList[indexPath.row].id}){
                    cell.checkImageView.isHidden = false
                    cell.imageView.alpha = 0.5
                }
            }
            cell.imageView.image = nil
            if let imageData = appData.appList[indexPath.row].app.image {
                cell.imageView.image = UIImage(data:imageData)
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppInfo", for: indexPath) as! AppInfoCell
            return cell
        }
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
        let value = CGFloat(sender.value)
        let currentSize = self.itemSize.width
        if value > maxSize {
            self.itemSize = CGSize(width:self.frame.width - 50,height:100)
        }else {
            self.itemSize = CGSize(width:value,height:value)
        }
        UserDefaults.standard.set(sender.value, forKey: "IconSize")
        
        self.collectionViewLayout.invalidateLayout()
        
        //cellが変わるときはreloadしたい
        if (currentSize >= value && currentSize <= maxSize ) || ( value >= maxSize && currentSize < value) {
            print("reloadData")
            self.reloadData()
        }
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
        }else {
            self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y = maxY - middleHeight
        }
        lastContentOffsetY = scrollView.contentOffset.y
        //self.appDelegate.baseVC.basePageVC.iconSizeChanger.isHidden = true
    }
    
    
}
