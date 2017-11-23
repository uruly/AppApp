//
//  LabelListTableViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol LabelListTableViewControllerDelegate {
    var shareVC:ShareViewController { get }
}

class LabelListTableViewController: UITableViewController {
    
    var list:[AppLabelData] = []
    var delegate:LabelListTableViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "labelList")
        self.tableView.allowsMultipleSelection = true
        
        readLabelData()
    }

    func readLabelData(){
        list = []
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        let objs = realm.objects(AppLabelRealmData.self)
        for obj in objs{
            if let name = obj.name ,let colorData = obj.color,let id = obj.id{
                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                let label = AppLabelData(name: name, color: color, id: id,order: obj.order)
                self.list.append(label)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {   //新しく作る
            return 1
        }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelList", for: indexPath)

        
        if indexPath.section == 1 {
            cell.textLabel?.text = "新しいラベルを作成"
        }else {
            cell.textLabel?.text = list[indexPath.row].name
            if self.delegate.shareVC.labelList.contains(where: {$0.id == list[indexPath.row].id}){
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
        }
        
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if self.delegate.shareVC.labelList.contains(where: {$0.id == list[indexPath.row].id}){
            //外す
            cell?.accessoryType = .none
            let index = self.delegate.shareVC.labelList.findIndex{$0.id == list[indexPath.row].id}
            if index.count > 0 {
                self.delegate.shareVC.labelList.remove(at: index[0])
            }
            
        }else {
            //つける
            cell?.accessoryType = .checkmark
            self.delegate.shareVC.labelList.append(list[indexPath.row])
        }
        
        cell?.isSelected = false
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.accessoryType = .none
//    }


}

extension Array where Element: Hashable {
    
    func unique() -> [Element] {
        var r = [Element]()
        for i in self {
            r += !r.contains(i) ? [i] : []
        }
        return r
    }
    
    mutating func uniqueInPlace() {
        self = self.unique()
    }
    
}

extension Array {
    func findIndex(includeElement: (Element) -> Bool) -> [Int] {
        var indexArray:[Int] = []
        for (index, element) in enumerated() {
            if includeElement(element) {
                indexArray.append(index)
            }
        }
        return indexArray
    }
}
