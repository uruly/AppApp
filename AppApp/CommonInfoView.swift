//
//  CommonInfoView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class CommonInfoView: UITableView {
    
    var developerName:String!
    var saveDate:String!
    var id:String!
    var headerTextList = ["基本情報"]

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.isScrollEnabled = false
        self.register(UITableViewCell.self, forCellReuseIdentifier: "AppInfo")
    }
    
    

}

extension CommonInfoView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
extension CommonInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTextList[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTextList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {   //基本情報
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfo", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        if indexPath.section == 0 {
            let label = UILabel(frame:CGRect(x:0,y:0,width:200,height:cell.contentView.frame.height))
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14)
            cell.accessoryView = label
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "開発者"
                label.text = developerName
            case 1:
                cell.textLabel?.text = "ID"
                label.text = id
            case 2:
                cell.textLabel?.text = "保存日時"
                label.text = saveDate
            default:
                cell.textLabel?.text = ""
            }
        }
        return cell
    }
}
