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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width:100,height:50)
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)
        self.pageVC = pageVC
    }

//    var diffX = {(nextIndex:Int) -> CGFloat in
//        if nextIndex > AppLabel.count || nextIndex < 0{
//            return 0
//        }
//        let nextCell = self.cellForItem(at: IndexPath(row: nextIndex, section: 0))
//        //寄せたい位置
//        let center = self.frame.width / 2
//
//        //次のセルの現在の中心位置
//        let nextCellPoint = self.convert(nextCell!.center, from: self.superview)
//        return center - nextCellPoint.x / self.frame.width
//    }
    var diffX:CGFloat = 0
    
    func setDiffX(nextIndex:Int){
        print("nextIndex\(nextIndex)")
        if nextIndex >= AppLabel.count! || nextIndex < 0{
            diffX = 0
            return
        }
        guard let nextCell = self.cellForItem(at: IndexPath(row: nextIndex, section: 0)) else {
            diffX = 0
            return
        }
        //寄せたい位置
        let center = self.frame.width / 2
        //次のセルの現在の中心位置
        let nextCellPoint = self.convert(nextCell.center, from: self.superview)
        
        if nextCellPoint.x - center != 0 {
            diffX = ( nextCellPoint.x - center ) / self.frame.width
        }
    }
    
    func scrollToHorizontallyCenter(index:Int,x:CGFloat){
        print(diffX)
        print(x)
        print("contentSize\(self.contentSize)")
        print("contentOffset.x\(self.contentOffset.x)")
        if self.contentOffset.x + (diffX * x) < 0{
            return
        }
        if self.contentOffset.x + (diffX * x) > contentSize.width - self.frame.width{
            return
        }
        self.contentOffset.x += (diffX * x)
    }
    
    func scrollAdjust(index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension SelectionBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //＋ボタンを押しているはず
        if indexPath.section == 1 {
            //ここでpageVC上のラベル追加関数を呼び出す
            pageVC.createAppLabel()
        }else {
            //ページビューを移動させる
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            let nextView:BaseViewController = pageVC.getBase(appLabel:pageVC.appLabel.array[indexPath.row])
            let isLeftDirection = AppLabel.currentID ?? 0 < indexPath.row
            if(isLeftDirection){
                pageVC.setViewControllers([nextView], direction: .forward, animated: true, completion: nil)
            }else{
                pageVC.setViewControllers([nextView], direction: .reverse, animated: true, completion: nil)
            }
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
extension SelectionBar:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("セレクションバースクロール中\(scrollView.contentOffset.x)")
    }
}
