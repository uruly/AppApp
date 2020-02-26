//
//  CommonInfoView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class CommonInfoView: UITableView {

    var developerName: String!
    var saveDate: String!
    var id: String!
    var isAppStore: Bool!
    var headerTextList = ["基本情報"]
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
    }

    override func reloadData() {
        super.reloadData()
        if detailVC != nil {
            detailVC.contentView.commonInfoFrame = CGSize(width: detailVC.view.frame.width, height: 200)
        }
    }

}

extension CommonInfoView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        cell.isSelected = false

        if let text = cell.textLabel?.text, text == "保存日時"{
            return
        }
        if let label = cell.accessoryView as? UILabel {
            detailVC.segueToWebView(label.text ?? "")
        }
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
            if isAppStore == nil {
                return 0
            }
            var count = 1
            if isAppStore { count += 1 }    //idを足す
            if developerName != "" { count += 1}    //developerを足す
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfo", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14 + VersionManager.excess)
        if indexPath.section == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 220, height: cell.contentView.frame.height))
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 14 + VersionManager.excess)
            cell.accessoryView = label
            if isAppStore != nil && isAppStore {
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
            } else if developerName != ""{
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "作成者"
                    label.text = developerName
                case 1:
                    cell.textLabel?.text = "保存日時"
                    label.text = saveDate
                default:
                    cell.textLabel?.text = ""
                }
            } else {
                cell.textLabel?.text = "保存日時"
                label.text = saveDate
            }
        }
        return cell
    }
}