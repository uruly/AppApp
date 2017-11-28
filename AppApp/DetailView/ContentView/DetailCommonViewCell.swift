//
//  DetailCommonViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DetailCommonViewCell: UICollectionViewCell {
    @IBOutlet weak var tableView: CommonInfoView!
    
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //widthLayout.constant = UIScreen.main.bounds.width - 30
        //tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppInfo")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //ここでcellの大きさを変えたい
        self.sizeToFit()
        print("layoutSubviewだよ")
    }

    func setTableViewDataSourceDelegate
        <D: UITableViewDataSource & UITableViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        tableView.reloadData()
        
    }
    
}
