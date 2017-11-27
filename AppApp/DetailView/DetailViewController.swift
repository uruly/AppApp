//
//  DetailViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/24.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift
import StoreKit

class DetailViewController: UIViewController {

    var appData:ApplicationStruct!
    var delegate:MemoDelegate!
    var contentView:DetailContentView!
    var memoText:String = ""{
        didSet {
            saveAppLabelMemo(memoText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height

        self.view.backgroundColor = UIColor.white
        self.title = appData.label.name
        
        let naviBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 57.0
        let margin:CGFloat = 15.0
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width:width - (margin * 2),height:200)
        layout.sectionInset = UIEdgeInsetsMake(15, 0, 30, 0)
        contentView = DetailContentView(frame: CGRect(x:0,y:0,width:width,height:height), collectionViewLayout: layout)
        self.view.addSubview(contentView)
        
        contentView.appName = appData.app.name
        contentView.imageData = appData.app.image
        contentView.detailVC = self
        contentView.memo = appData.memo
        contentView.developerName = appData.app.developer
        contentView.id = appData.app.id
        contentView.saveDate = convertDate(appData.app.date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            var existsSelfInViewControllers = true
            for viewController in viewControllers {
                if viewController == self {
                    existsSelfInViewControllers = false
                    // selfが存在した時点で処理を終える
                    break
                }
            }

            if existsSelfInViewControllers {
                print("前の画面に戻る処理が行われました")
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.navigationController?.navigationBar.barTintColor = UIColor.white
//                    self.navigationController?.navigationBar.tintColor = nil
//                })
                
            }
        }
        super.viewWillDisappear(animated)
    }
    
    func convertDate(_ date:Date) -> String {
        let component = Calendar.current.dateComponents([.year,.month,.day], from: date)
        let text = "\(component.year!)年\(component.month!)月\(component.day!)日"
        return text
        
    }
    
    func segueToWebView(_ text:String){
        let webVC = WebViewController()
        webVC.searchWord = text
        self.navigationController?.pushViewController(webVC, animated: true)
    }

    
    func saveAppLabelMemo(_ text:String ){
        print("saveMemo")
        var config = Realm.Configuration(schemaVersion:SCHEMA_VERSION)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        
        guard let obj = realm.object(ofType: ApplicationData.self, forPrimaryKey: appData.id) else {
            return
        }
        try! realm.write {
            obj.memo = text
            realm.add(obj, update: true)
        }
    }
    
    @objc func showProductPage() {
        let productVC = SKStoreProductViewController()
        productVC.delegate = self
        
        guard var id = appData.app.id else { return }
        if let range = id.range(of: "id") {
            // 置換する(変数を直接操作する)
            id.replaceSubrange(range, with: "")
        }
        self.present(productVC, animated: true) {
            productVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:id]) { (bool, error) in
//                if !bool {
//                    productVC.dismiss(animated: true, completion: nil)
//                }
                print(error)
            }
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate.scroll()
    }
}

extension DetailViewController : SKStoreProductViewControllerDelegate {
    // キャンセルボタンが押された時の処理
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
