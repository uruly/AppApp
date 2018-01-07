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
    var itemSize:CGSize!
    var lastContentOffsetY:CGFloat = 0
    var maxSize:CGFloat = 160.0
    var appDelegate:AppCollectionViewDelegate! {
        didSet{
//            if appDelegate.baseVC.appLabel.name == "ALL" {
//                appData = AppData(allLabel:appDelegate.baseVC.appLabel)
//            }else {
//                appData = AppData(label:appDelegate.baseVC.appLabel)
//            }
            DispatchQueue.global().async {
                self.appData = AppData(label:self.appDelegate.baseVC.appLabel)
            }
        }
    }
    var appData:AppData! {
        didSet {
            //print("self.itemSize\(self.itemSize)")
            //self.collectionViewLayout.invalidateLayout()
            DispatchQueue.main.async {
                self.reloadData()
                //self.backgroundColor = self.appData.label.color
            }
            //self.collectionViewLayout.invalidateLayout()
        }
    }
    
    var checkArray:[ApplicationStruct] = []
    
    var mode:ToolbarMode! {
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
        self.register(UINib(nibName:"AppInfoCell",bundle:nil), forCellWithReuseIdentifier: "AppInfo")
        self.backgroundColor = UIColor.white
        
        //モードを決めておく
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "isList"){
            self.mode = .list
        }else {
            self.mode = .collect
        }
        
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
        }else{  //設定されているとき
//            if iconSize > 160.0 {
//                print("iconSize\(iconSize)")
//                layout.itemSize = CGSize(width:frame.width - 30,height:100)
//            }else {
                //print("iconSizeElse\(iconSize)")
                layout.itemSize = CGSize(width:iconSize,height:iconSize)
//            }
        }
        self.init(frame:frame,collectionViewLayout:layout)
        self.itemSize = layout.itemSize
//        print(self.itemSize)
//        self.reloadData()
    }
    
    override func reloadData(){
        if appData != nil {
            //背景色をつける
            if let color = AppLabel.currentBackgroundColor{
                if BackgroundColorListView.isDefaultColor && color != UIColor.white{ //whiteでないときはラベル色
                    self.backgroundColor = self.appData.label.color
                }else {
                    self.backgroundColor = color
                }
            }else {
                self.backgroundColor = mode == .collect ? UIColor.white : self.appData.label.color
                //AppLabel.currentBackgroundColor = self.backgroundColor
            }
            if let pageVC:BasePageViewController = findViewController() {
                if let bottomBaseView = pageVC.bottomView.baseView{
                    bottomBaseView.reloadData()
                }
            }
            if let backImage = AppLabel.currentBackgroundImage{
                print("kononaka")
                self.backgroundColor = UIColor(patternImage: backImage)
            }
            
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
    
    func deleteAppData(_ completion:@escaping ()->()){
        DispatchQueue.global().async {
            //print(self.checkArray)
            self.appData.deleteAppData(appList: self.checkArray){
                if self.checkArray.count > 0 {
                    self.appData.readAppData(label: self.checkArray[0].label){
                        self.appData.resetOrder()
                        DispatchQueue.main.async {
                            let removeRows = self.checkArray.map{$0.order}
                            var indexPaths:[IndexPath] = []
                            for row in removeRows {
                                let indexPath = IndexPath(row: row!, section: 0)
                                print("row\(row)")
                                indexPaths.append(indexPath)
                            }
                            self.deleteItems(at: indexPaths)
                            self.checkArray = []
                            //ここでorderが変わっているのを反映したい.
                            
                            completion()
                        }
                    }
                }
            }
        }
    }
}

extension AppCollectionView:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppCollectionView.isWhileEditing {
            if mode == .collect {
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
            }else {
                let cell:AppInfoCell = collectionView.cellForItem(at: indexPath) as! AppInfoCell
                
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
            self.appDelegate.baseVC.toDetailViewController(appData:appData.appList[indexPath.row])
        }
    }
}

extension AppCollectionView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if mode == .collect {
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
            cell.imageView.image = nil
            if let imageData = appData.appList[indexPath.row].app.image {
                cell.imageView.image = UIImage(data:imageData)
            }
            cell.nameLabel.text = appData.appList[indexPath.row].app.name
            cell.developerLabel.text = appData.appList[indexPath.row].app.developer
            
            //チェックマーク
            cell.checkImageView.isHidden = true
            cell.imageView.alpha = 1.0
            //編集中かどうか
            if AppCollectionView.isWhileEditing {
                if checkArray.contains(where: {$0.id == appData.appList[indexPath.row].id}){
                    cell.checkImageView.isHidden = false
                    cell.imageView.alpha = 0.5
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if appData == nil {
            return 0
        }
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
        if mode == .collect {
            return itemSize
        }else {
            return CGSize(width:self.frame.width - 30,height:125)
        }
    }
}

extension AppCollectionView:IconSizeChangerDelegate{
    @objc func sliderValueChanged(sender: UISlider) {
        //print("ここで受け取り！\(sender.value)")
        //collectionViewのitemSizeを変える
        let value = CGFloat(sender.value)
       // let currentSize = self.itemSize.width
//        if value > maxSize {
//            self.itemSize = CGSize(width:self.frame.width - 30,height:100)
//        }else {
//            self.itemSize = CGSize(width:value,height:value)
//        }
        self.itemSize = CGSize(width:value,height:value)
        UserDefaults.standard.set(sender.value, forKey: "IconSize")
        
        self.collectionViewLayout.invalidateLayout()
        
        //cellが変わるときはreloadしたい
//        if (currentSize >= value && currentSize <= maxSize ) || ( value >= maxSize && currentSize < value) {
//            print("reloadData")
//            self.reloadData()
//        }
    }
    var collectionView:AppCollectionView{
        return self
    }
}

extension AppCollectionView:UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if let view = self.appDelegate.baseVC.basePageVC.view.viewWithTag(543){
//            view.removeFromSuperview()
//        }
//        lastContentOffsetY = scrollView.contentOffset.y
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //print("offsetY\(scrollView.contentOffset.y)")
//        let maxY = self.appDelegate.baseVC.view.frame.maxY
//        let middleHeight = self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.height / 2
//        let minY = maxY - ( middleHeight * 2 )
//        let diffX = fabs(lastContentOffsetY - scrollView.contentOffset.y)
//        let frameMinY = self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.minY
//        //let frameMaxY = self.appDelegate.baseVC.basePageVC.iconSizeChanger.frame.maxY
//        //let currentFrameCenterY = self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y
//        let frameMaxY = self.contentSize.height - (middleHeight * 2) - maxY
//        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= frameMaxY{
//            if scrollView.contentOffset.y > lastContentOffsetY {
//                //どんどん非表示
//                if ( frameMinY + diffX ) >= maxY {
//                    //非表示で固定
//                    self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y = maxY + middleHeight
//                }else {
//                    //移動させる
//                    self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y += diffX
//                }
//            }else {
//                //どんどん表示
//                if ( frameMinY + diffX ) <= minY || frameMinY <= minY{
//                    //表示で固定
//                    self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y = minY + middleHeight
//                }else {
//                    //移動させる
//                    self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y -= diffX
//                }
//            }
//        }else {
//            //表示で固定
//            self.appDelegate.baseVC.basePageVC.iconSizeChanger.center.y = minY + middleHeight
//        }
//        lastContentOffsetY = scrollView.contentOffset.y
//        //self.appDelegate.baseVC.basePageVC.iconSizeChanger.isHidden = true
//    }
//    
    
}
