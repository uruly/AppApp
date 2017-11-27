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
    var scrollView:UIScrollView!
    var appInfoView:AppInfoView!
    var commonInfoView:CommonInfoView!
    var labelInfoView:LabelAppInfoView!
    var delegate:MemoDelegate!
    var memoText:String = ""{
        didSet {
            saveAppLabelMemo(memoText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height

        self.view.backgroundColor = UIColor.backgroundGray()
        self.title = appData.label.name
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x:0,y:0,width:width,height:height)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        let naviBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 57.0
        let margin:CGFloat = 15.0
        appInfoView = AppInfoView(frame:CGRect(x:margin,y:margin,width:width - (margin * 2),height:180))
        appInfoView.appName = appData.app.name
        appInfoView.imageData = appData.app.image
        appInfoView.detailVC = self
        appInfoView.setSubviews()
        scrollView.addSubview(appInfoView)
        
        labelInfoView = LabelAppInfoView(frame: CGRect(x:margin,y:appInfoView.frame.maxY + margin,
                                                       width:width - (margin * 2 ),
                                                       height:200),
                                         style: .grouped)
        self.delegate = labelInfoView
        labelInfoView.detailVC = self
        labelInfoView.memo = appData.memo ?? "メモ"
        scrollView.addSubview(labelInfoView)
        
        commonInfoView = CommonInfoView(frame: CGRect(x:margin,y:labelInfoView.frame.maxY + margin,
                                              width:width - (margin * 2 ),
                                              height:200),
                                style: .grouped)
        commonInfoView.developerName = appData.app.developer
        commonInfoView.id = appData.app.id
        commonInfoView.saveDate = convertDate(appData.app.date)
        commonInfoView.detailVC = self
        scrollView.addSubview(commonInfoView)
        
        
        //AppStoreで見る
        
        //アプリを全てのラベルから削除するボタン
        
//        let itunesURL:String = appData.app.urlString
//        let url = URL(string:itunesURL)
//        let app:UIApplication = UIApplication.shared
//        app.openURL(url!)
        
        
        scrollView.contentSize = CGSize(width:width,height:commonInfoView.frame.maxY + 200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        if let viewControllers = self.navigationController?.viewControllers {
//            var existsSelfInViewControllers = true
//            for viewController in viewControllers {
//                if viewController == self {
//                    existsSelfInViewControllers = false
//                    // selfが存在した時点で処理を終える
//                    break
//                }
//            }
//
//            if existsSelfInViewControllers {
//                print("前の画面に戻る処理が行われました")
//                if memoText != "" {
//                    self.saveAppLabelMemo(memoText)
//                }
//            }
//        }
//        super.viewWillDisappear(animated)
//    }
    
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
//        presentViewController( productViewController, animated: true, completion: {() -> Void in
//
//            let productID = "710247888" // 調べたアプリのID
//            let parameters:Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
//            productViewController.loadProductWithParameters( parameters, completionBlock: {(Bool, NSError) -> Void in
//                // 読み込み完了またはエラーのときの処理
//                // ...
//            })
//        })
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
