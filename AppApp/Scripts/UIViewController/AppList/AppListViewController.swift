//
//  AppListViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

class AppListViewController: UIViewController {

    var checkArray: [App] = [] {
        didSet {
            createAppLabelVC.appList = checkArray
        }
    }
    var appList: [App] = []
    var collectionView: UICollectionView!
    //var naviBar:CustomNavigationBar!
    var createAppLabelVC: CreateAppLabelViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = R.color.whiteFlowerColor()!
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Appを追加"
        //コレクションビューで追加するアプリを表示したい
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 15, bottom: 20, right: 15)
        let naviBarHeight = self.navigationController?.navigationBar.frame.height ?? 57.0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: naviBarHeight, width: width, height: height - naviBarHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.appListCollectionViewCell)
        collectionView.backgroundColor = R.color.whiteFlowerColor()!
        self.view.addSubview(collectionView)

        readData()
    }

    func readData() {
        appList = []
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)

        //全てのデータを取り出す
        guard let label = realm.object(ofType: Label.self, forPrimaryKey: "0") else {
            return
        }
        let objs = realm.objects(ApplicationData.self).filter("label == %@", label)
        for obj in objs {
            guard let app = obj.app else { return }
            //            let appData = AppStruct(name: app.name, developer: app.developer, id: app.id, urlString: app.urlString, image: app.image, date: app.date)
            //
            //            //現在のappを表示
            //            if let editVC = createAppLabelVC as? EditAppLabelViewController {
            //                let labelID = editVC.id
            //                if let currentLabel = realm.object(ofType: Label.self, forPrimaryKey: labelID) {
            //                    let currentLabelApp = realm.objects(ApplicationData.self).filter("label == %@ && app == %@", currentLabel, obj.app!)
            //                    if currentLabelApp.count > 0 {
            //                        //print("すでにあるよ")
            //                        continue
            //                    }
            //                }
            //            }
            //
            //            appList.append(appData)
        }
    }

    @objc func cancelBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func saveBtnTapped(sender: UIBarButtonItem) {
        if sender.tintColor != nil {
            return
        }
        //        //セーブする
        //        AppData.saveAppData(appList: self.appList, labelList: self.checkArray) {
        //
        //            self.dismiss(animated: true, completion: nil)
        //        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AppListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: AppListCollectionViewCell = collectionView.cellForItem(at: indexPath) as! AppListCollectionViewCell

        let id = appList[indexPath.row].id
        let index = checkArray.findIndex(includeElement: {$0.id == id})
        if index.count > 0 {
            self.checkArray.remove(at: index[0])
            cell.checkImageView.isHidden = true
            cell.imageView.alpha = 1.0
        } else {
            self.checkArray.append(appList[indexPath.row])
            cell.checkImageView.isHidden = false
            cell.imageView.alpha = 0.5
        }
    }
}

extension AppListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AppListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "app", for: indexPath) as! AppListCollectionViewCell

        //        cell.imageView.image = UIImage(data: appList[indexPath.row].image)

        if createAppLabelVC.appList.contains(where: {$0.id == appList[indexPath.row].id}) {
            cell.checkImageView.isHidden = false
            cell.imageView.alpha = 0.5
        } else {
            cell.checkImageView.isHidden = true
            cell.imageView.alpha = 1
        }

        return cell
    }
}
