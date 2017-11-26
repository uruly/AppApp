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
        
        //長押しで
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(sender:)))
        longPress.allowableMovement = 10
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(cellDoubleTapped(sender:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
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
    
    @objc func cellDoubleTapped(sender:UITapGestureRecognizer){
        //長押ししたら編集画面になる
        guard let indexPath = self.indexPathForItem(at: sender.location(in:self)) else {
            return
        }
        if indexPath.section == 1 {
            return
        }
        
        pageVC.editAppLabel(label:pageVC.appLabel.array[indexPath.row])
    }
    @objc func cellLongPressed(sender:UILongPressGestureRecognizer){
        
        
        switch(sender.state) {
            
        case .began:
            guard let selectedIndexPath = self.indexPathForItem(at: sender.location(in:self)) else {
                break
            }
            if selectedIndexPath.section == 1 || selectedIndexPath.row == 0{
                return
            }
            self.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            print("changed")
            self.updateInteractiveMovementTargetPosition(sender.location(in: sender.view!))
            
        case .ended:
            print("end")
            guard let nextIndexPath = self.indexPathForItem(at: sender.location(in: sender.view!)) else {
                break
            }
            print(nextIndexPath)
            if nextIndexPath.section == 1 || nextIndexPath.row == 0{
                self.cancelInteractiveMovement()
            }else {
                self.endInteractiveMovement()
            }
            
        default:
            self.cancelInteractiveMovement()
        }
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
            
            if AppLabel.currentOrder == indexPath.row {
                print("return\(AppLabel.currentOrder)")
                return
            }
            
            let nextView:BaseViewController = pageVC.getBase(appLabel:pageVC.appLabel.array[indexPath.row])
            let isLeftDirection = (AppLabel.currentOrder ?? 0) < indexPath.row
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
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("sourceIndexPath\(sourceIndexPath.section)\(destinationIndexPath.section)")

        //collectionViewLayout.invalidateLayout()
        let tempNumber = pageVC.appLabel.array.remove(at: sourceIndexPath.item)
        pageVC.appLabel.array.insert(tempNumber, at: destinationIndexPath.item)
        //appLabelのorderを更新
        pageVC.appLabel.resetOrder()
        //self.reloadData()
        self.layoutIfNeeded()
        //self.collectionViewLayout.invalidateLayout()
        print(sourceIndexPath.item)

        pageVC.reloadPage(order:AppLabel.currentOrder!)
    }
    
}
extension SelectionBar:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("セレクションバースクロール中\(scrollView.contentOffset.x)")
    }
}

//extension UICollectionViewFlowLayout {
//
//    open override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
//
//        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
//
//        //Check that the movement has actually happeneds
//        if previousIndexPaths.first!.item != targetIndexPaths.first!.item {
//            collectionView?.dataSource?.collectionView?(collectionView!, moveItemAt: previousIndexPaths.first!, to: targetIndexPaths.last!)
//        }
//
//        return context
//    }
//
//    open override func invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths indexPaths: [IndexPath], previousIndexPaths: [IndexPath], movementCancelled: Bool) -> UICollectionViewLayoutInvalidationContext {
//        return super.invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths: indexPaths, previousIndexPaths: previousIndexPaths, movementCancelled: movementCancelled)
//    }
//
//    open override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
//        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
//        attributes.alpha = 0.8
//        return attributes
//    }
//}

