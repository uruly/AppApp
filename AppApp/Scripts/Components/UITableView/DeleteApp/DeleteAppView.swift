//
//  DeleteAppView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/28.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DeleteAppView: UITableView {

    var headerTextList = ["Appを削除"]
    var labelName: String = ""
    var detailVC: DetailViewController!
    //var widthLayout:CGFloat!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        //print("ここ呼ばれている？？？？")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.isScrollEnabled = false
        self.register(UITableViewCell.self, forCellReuseIdentifier: "AppInfo")
        //self.estimatedRowHeight = 150
        //self.rowHeight = UITableViewAutomaticDimension
    }

    override func reloadData() {
        super.reloadData()
        if detailVC != nil {
            if detailVC.appData.label.id == "0" {
                detailVC.contentView.deleteViewFrame = CGSize(width: detailVC.view.frame.width, height: 100)
            } else {
                detailVC.contentView.deleteViewFrame = CGSize(width: detailVC.view.frame.width, height: 150)
            }
        }
    }

}
extension DeleteAppView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false

        if detailVC.appData.label.id == "0" {
            detailVC.deleteAppAllData()
        } else {
            if indexPath.row == 0 {
                detailVC.deleteAppLabelData()
            }
            if indexPath.row == 1 {
                detailVC.deleteAppAllData()
            }
        }
    }
}
extension DeleteAppView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTextList[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTextList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {   //基本情報
            if detailVC.appData.label.id == "0" {
                return 1
            } else {
                return 2
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfo", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        if indexPath.section == 0 && detailVC.appData.label.id != "0" {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Appを「\(labelName)」から削除する"
            case 1:
                cell.textLabel?.text = "全てのラベルからAppを削除する"
            default:
                cell.textLabel?.text = ""
            }
        } else {
            cell.textLabel?.text = "全てのラベルからAppを削除する"
        }
        return cell
    }
}