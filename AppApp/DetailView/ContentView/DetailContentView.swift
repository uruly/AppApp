//
//  DetailContentView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DetailContentView: UICollectionView {

    var appName:String!
    var imageData:Data!
    var detailVC:DetailViewController!
    var memo:String!
    var developerName:String!
    var id:String!
    var saveDate:String!
    var memoDelegate:MemoDelegate!
    var topInfoFrame:CGSize = CGSize.zero {
        didSet{
            self.collectionViewLayout.invalidateLayout()
        }
    }
    var memoViewFrame:CGSize = CGSize.zero {
        didSet {
            self.collectionViewLayout.invalidateLayout()
        }
    }
    var commonInfoFrame:CGSize = CGSize.zero {
        didSet {
            self.collectionViewLayout.invalidateLayout()
        }
    }
    var deleteViewFrame:CGSize = CGSize.zero {
        didSet {
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName:"DetailMemoViewCell",bundle:nil), forCellWithReuseIdentifier: "detailMemo")
        self.register(UINib(nibName:"DetailCommonViewCell",bundle:nil), forCellWithReuseIdentifier: "detailCommon")
        self.register(UINib(nibName:"DetailAppInfoViewCell",bundle:nil), forCellWithReuseIdentifier: "detailAppInfo")
        self.register(UINib(nibName:"DeleteViewCell",bundle:nil),forCellWithReuseIdentifier: "deleteApp")
    }
    
    func scrollToMemoView(){
        let indexPath = IndexPath(row: 2, section: 0)
        scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
}

extension DetailContentView:UICollectionViewDelegate {
    
}

extension DetailContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailAppInfo", for: indexPath) as! DetailAppInfoViewCell
            for subview in cell.infoView.subviews  {
                subview.removeFromSuperview()
            }
            cell.infoView.appName = self.appName
            cell.infoView.imageData = self.imageData
            cell.infoView.detailVC = self.detailVC
            cell.infoView.setSubviews()
            //cell.infoView.widthLayout = self.frame.width - 30
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCommon", for: indexPath) as! DetailCommonViewCell
            cell.tableView.developerName = self.developerName
            cell.tableView.id = self.id
            cell.tableView.saveDate = self.saveDate
            cell.tableView.detailVC = self.detailVC
            //cell.tableView.widthLayout = self.frame.width - 30
            cell.tableView.reloadData()
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailMemo", for: indexPath) as! DetailMemoViewCell
            print("ここにはきてる")
            self.detailVC.delegate = cell.tableView
            cell.tableView.detailVC = self.detailVC
            cell.tableView.memo = memo
            self.memoDelegate = cell.tableView
            //cell.tableView = self.frame.width - 30
            cell.tableView.reloadData()
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deleteApp", for: indexPath) as! DeleteViewCell
            cell.tableView.detailVC = self.detailVC
            cell.tableView.labelName = self.detailVC.appData.label.name
            
            return cell
        }
    }
}
extension DetailContentView:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return topInfoFrame
        case 1: return commonInfoFrame
        case 2: return memoViewFrame
        case 3: return deleteViewFrame
        default:
            return CGSize(width:self.frame.width,height:100)
        }
    }
}

extension DetailContentView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("begin")
        if memoDelegate != nil {
            memoDelegate.scroll()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("beginDrag")
    }
}

