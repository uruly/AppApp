//
//  LabelListViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/25.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

//@objc protocol LabelListViewControllerDelegate {
//    //var baseVC:BaseViewController { get }
//}

class LabelListViewController: UIViewController {
    
    var list:[AppLabelData] = []
    var checkArray:[AppLabelData] = []{
        didSet{
            if checkArray.count > 0 {
                if (self.naviBar.items?.count ?? 0) > 0 {
                    self.naviBar.items![0].rightBarButtonItem?.tintColor = nil
                }
            }else {
                if (self.naviBar.items?.count ?? 0) > 0 {
                    self.naviBar.items![0].rightBarButtonItem?.tintColor = UIColor.lightGray
                }
            }
        }
    }
    var tableView:UITableView!
    var appList:[ApplicationStruct] = []
    var collectionView:UICollectionView!
    var naviBar:CustomNavigationBar!
    var baseVC:BaseViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = UIColor.backgroundGray()
        //ナビゲーションバーを設置
        let naviBarHeight = UIApplication.shared.statusBarFrame.height + 47.0
        //print(naviBarHeight)
        naviBar = CustomNavigationBar(frame: CGRect(x:0,y:0,width:width,height:naviBarHeight))
        let naviBarItem = UINavigationItem(title:"ラベルを追加")
        let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.cancelBtnTapped))
        let saveBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveBtnTapped(sender:)))
        saveBtn.tintColor = UIColor.lightGray    //まだ押せない
        naviBarItem.leftBarButtonItem = cancelBtn
        naviBarItem.rightBarButtonItem = saveBtn
        naviBar.items = [naviBarItem]
        self.view.addSubview(naviBar)
        
        //コレクションビューで追加するアプリを表示したい
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:50,height:50)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        collectionView = UICollectionView(frame: CGRect(x:0,y:naviBarHeight,width:width,height:70), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"AppCollectionViewCell",bundle:nil), forCellWithReuseIdentifier: "app")
        collectionView.backgroundColor = UIColor.backgroundGray()
        self.view.addSubview(collectionView)
        
        
        tableView = UITableView(frame: CGRect(x:0,y:collectionView.frame.maxY,width:width,height:height - collectionView.frame.maxY), style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "labelList")
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.backgroundGray()
        //tableView.sectionHeaderHeight = 0
        //tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.view.addSubview(tableView)
        
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
            if obj.id == "0" {
                continue
            }
            if let name = obj.name ,let colorData = obj.color,let id = obj.id{
                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                let label = AppLabelData(name: name, color: color, id: id,order: obj.order,explain:obj.explain)
                self.list.append(label)
            }
        }
    }
    
    @objc func cancelBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnTapped(sender:UIBarButtonItem){
        if sender.tintColor != nil {
            return
        }
        //セーブする
        AppData.saveAppData(appList: self.appList, labelList: self.checkArray) {
            BasePageViewController.isUnwind = true
            AppCollectionView.isWhileEditing = false
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension LabelListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if self.checkArray.contains(where: {$0.id == list[indexPath.row].id}){
            //外す
            cell?.accessoryType = .none
            let index = self.checkArray.findIndex{$0.id == list[indexPath.row].id}
            if index.count > 0 {
                self.checkArray.remove(at: index[0])
            }
            
        }else {
            //つける
            cell?.accessoryType = .checkmark
            self.checkArray.append(list[indexPath.row])
        }
        
        cell?.isSelected = false
    }
}

extension LabelListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelList", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row].name
        cell.detailTextLabel?.text = list[indexPath.row].explain
        if self.checkArray.contains(where: {$0.id == list[indexPath.row].id}){
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
}

extension LabelListViewController: UICollectionViewDelegate {
    
}

extension LabelListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AppCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "app", for: indexPath) as! AppCollectionViewCell
        
        cell.imageView.image = UIImage(data:appList[indexPath.row].app.image)
        
        return cell
    }
}
