//
//  InfoTableView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit
@objc protocol InfoTableViewDelegate {
    var pageVC:BasePageViewController { get }
}

class InfoTableView: UITableView {
    
    var labelArray:[AppLabelData] = []
    var checkArray:[AppLabelData] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "common")
        self.register(UITableViewCell.self, forCellReuseIdentifier: "label")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        
        let appLabel = AppLabel()
        labelArray = appLabel.array
    }
    
    convenience init(frame:CGRect){
        self.init(frame:frame,style:.grouped)
    }

}

extension InfoTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.isSelected = false
        cell.isHighlighted = false
        
        if indexPath.section == 2 {
            let indexArray = checkArray.findIndex(includeElement: { (data) -> Bool in
                return data.name == ( cell.textLabel?.text ?? "" )
            })
            if indexArray.count > 0{
                //外す
                checkArray.remove(at:indexArray[0])
                cell.accessoryType = .none
            }else {
                //つける
                checkArray.append(labelArray[indexPath.row])
                cell.accessoryType = .checkmark
            }
        }
    }
}

extension InfoTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 1
        case 2: return labelArray.count   //ここは可変がgoodかも
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "common", for: indexPath)
            cell.isSelected = false
            cell.isHighlighted = false
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "common", for: indexPath)
            cell.isSelected = false
            cell.isHighlighted = false
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "label", for: indexPath)
            cell.isSelected = false
            cell.isHighlighted = false
            cell.textLabel?.text = labelArray[indexPath.row].name
            if checkArray.contains(where: { (data) -> Bool in
                return data.name == labelArray[indexPath.row].name
            }){
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //基本情報、メモ、つけるラベル
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.tableHeaderView?.backgroundColor = UIColor.white
        self.tableFooterView?.backgroundColor = UIColor.white
        switch section {
        case 0:
            return "基本情報"
        case 1:
            return "メモ"
        case 2:
            return "ラベル"
        default: return ""
        }
    }
    
    
}
