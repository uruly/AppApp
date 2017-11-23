//
//  BaseViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//
// コレクションビューを乗せてページングさせるビューコントローラ

import UIKit
import RealmSwift

class BaseViewController: UIViewController {

    var appLabel:AppLabelData!
    var collectionView:AppCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        self.view.backgroundColor = appLabel.color

        //とりあえず仮のラベル
        let label = UILabel()
        label.frame = CGRect(x:0,y:0,width:100,height:50)
        label.center = CGPoint(x:width / 2,y:height / 2)
        label.text = appLabel.name
        self.view.addSubview(label)
        
        //コレクションビューを配置
        let topMargin = basePageVC.selectionBar.frame.maxY + 7  //+部分がラインになる
        collectionView = AppCollectionView(frame: CGRect(x:0,
                                                             y:topMargin,
                                                             width:width,
                                                             height:height - topMargin ))
        self.view.addSubview(collectionView)
        
        
        //とりあえずお試し
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        
        let realm = try! Realm(configuration: config)
        let objs = realm.objects(ApplicationData.self)
        print(objs)
        for obj in objs{
            print(obj.app)
            print(obj)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ここでCurrentIDを設定
        AppLabel.currentID = appLabel.order
        
        //delegateを設定
        if self.basePageVC.iconSizeChanger != nil {
            self.basePageVC.iconSizeChanger.sliderDelegate = collectionView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BaseViewController: BasePageViewControllerDelegate {
    var basePageVC:BasePageViewController {
        return parent as! BasePageViewController
    }
}

