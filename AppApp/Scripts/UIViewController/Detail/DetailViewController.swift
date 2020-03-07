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

    var appData: ApplicationData!
    var canSetObserver = true
    var delegate: MemoDelegate! {
        didSet {
            if canSetObserver {
                NotificationCenter.default.addObserver(
                    delegate,
                    selector: #selector(delegate.labelAppInfoView.showKeyboard(notification:)),
                    name: UIResponder.keyboardDidShowNotification,
                    object: nil
                )
                NotificationCenter.default.addObserver(
                    delegate,
                    selector: #selector(delegate.labelAppInfoView.dismissKeyboard(notification:)),
                    name: UIResponder.keyboardDidHideNotification,
                    object: nil
                )
                canSetObserver = false
            }
        }
    }
    var contentView: DetailContentView!
    var memoText: String = ""{
        didSet {
            saveAppLabelMemo(memoText)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height

        //self.view.backgroundColor = UIColor.white
        self.title = appData.label?.name

        //let naviBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 57.0
        //let margin:CGFloat = 15.0

        let layout = UICollectionViewFlowLayout()
        //layout.estimatedItemSize = CGSize(width:width - (margin * 2),height:200)
        layout.itemSize = CGSize(width: self.view.frame.width, height: 500)
        layout.sectionInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 50, right: 0)
        contentView = DetailContentView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        self.view.addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        contentView.appName = appData.app?.name
        //print("appData.app\(appData.app.urlString)")
        contentView.url = appData.app?.urlString
        contentView.imageData = appData.app?.image
        contentView.detailVC = self
        contentView.memo = appData.memo
        contentView.developerName = appData.app?.developer
        contentView.id = appData.app?.id
        contentView.saveDate = convertDate(appData.app?.date ?? Date())

        //        self.view.backgroundColor = appData.label?.color
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "search") {
            let rect = CGRect(x: self.view.frame.width - 315, y: self.view.frame.height * 1 / 3, width: 300, height: 60)
            let balloonView = BalloonView(frame: rect, color: R.color.yellowColor()!)
            balloonView.isDown = true
            balloonView.tag = 543
            balloonView.label.text = "タップすると開発者名やIDをWebで検索"
            balloonView.label.textColor = UIColor.white
            self.view.addSubview(balloonView)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseIn], animations: {
                balloonView.center.y += 5.0
            }, completion: nil)
            userDefaults.set(true, forKey: "search")
        }
        self.navigationController?.navigationBar.barTintColor = nil
        //        self.navigationController?.navigationBar.backgroundColor = self.appData.label?.color.withAlphaComponent(0.8)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            var existsSelfInViewControllers = true
            for viewController in viewControllers where viewController == self {
                existsSelfInViewControllers = false
                // selfが存在した時点で処理を終える
                break
            }

            if existsSelfInViewControllers {
                //print("前の画面に戻る処理が行われました")
                UIView.animate(withDuration: 0.3, animations: {
                    self.navigationController?.navigationBar.barTintColor = UIColor.white
                    self.navigationController?.navigationBar.tintColor = nil
                })

            }
        }
        super.viewWillDisappear(animated)
    }

    func convertDate(_ date: Date) -> String {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let text = "\(component.year!)年\(component.month!)月\(component.day!)日"
        return text

    }

    func segueToWebView(_ text: String) {
        let webVC = WebViewController()
        webVC.searchWord = text
        self.navigationController?.pushViewController(webVC, animated: true)
    }

    func saveAppLabelMemo(_ text: String ) {
        //print("saveMemo")
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)

        guard let obj = realm.object(ofType: ApplicationData.self, forPrimaryKey: appData.id) else {
            return
        }
        try! realm.write {
            obj.memo = text
            realm.add(obj, update: .all)
        }
    }

    @objc func showProductPage() {
        let productVC = SKStoreProductViewController()
        productVC.delegate = self

        guard var id = appData.app?.id else { return }
        if let range = id.range(of: "id") {
            // 置換する(変数を直接操作する)
            id.replaceSubrange(range, with: "")
        }
        self.present(productVC, animated: true) {
            productVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: id]) { (_, error) in
                //                if !bool {
                //                    productVC.dismiss(animated: true, completion: nil)
                //                }
                if error != nil {
                    productVC.dismiss(animated: true, completion: nil)
                }
                //print(error)
            }
        }
    }

    func deleteAppAllData() {
        //        let alertController = UIAlertController(title: "Appを全て削除", message: "全てのラベルからAppを削除します", preferredStyle: .alert)
        //        alertController.addAction(UIAlertAction(title: "削除する", style: .default) { [weak self] _ in
        //            guard let appData = self?.appData else { return }
        //            AppData.deleteAppAllData(app: appData, {
        //                self.navigationController?.popViewController(animated: true)
        //            })
        //        })
        //        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        //        present(alertController, animated: true, completion: nil)
    }

    func deleteAppLabelData() {
        let alertController = UIAlertController(title: "\(appData.label?.name!)からAppを削除", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "削除する", style: .default) { _ in
            AppData.deleteAppData(app: self.appData, {
                self.navigationController?.popViewController(animated: true)
            })
        })
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alertController, animated: true, completion: nil)
    }
}

extension DetailViewController: SKStoreProductViewControllerDelegate {
    // キャンセルボタンが押された時の処理
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dismiss(animated: true, completion: nil)
    }

}
