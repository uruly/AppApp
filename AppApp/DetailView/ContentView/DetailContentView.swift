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
    }
    
}

extension DetailContentView:UICollectionViewDelegate {
    
}

extension DetailContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailAppInfo", for: indexPath) as! DetailAppInfoViewCell
            
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
        //else if indexPath.row == 2 {
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailMemo", for: indexPath) as! DetailMemoViewCell
            
            self.detailVC.delegate = cell.tableView
            cell.tableView.detailVC = self.detailVC
            cell.tableView.memo = memo
            //cell.tableView = self.frame.width - 30
            cell.tableView.reloadData()
            
            return cell
        }
    }
}
