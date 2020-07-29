//
//  ShareViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import Social
import RealmSwift

class ShareViewController: SLComposeServiceViewController {

    var id: String?
    var name: String?
    var url: String = ""
    var developer = ""
    var image: Data?

    lazy var labelItem: SLComposeSheetConfigurationItem? = {
        guard let item = SLComposeSheetConfigurationItem() else {
            return nil
        }
        item.title = "ラベル"
        item.value = "ALL"
        item.tapHandler = self.showLabelList
        return item
    }()

    lazy var memoItem: SLComposeSheetConfigurationItem? = {
        guard let item = SLComposeSheetConfigurationItem() else {
            return nil
        }
        item.title = "メモ"
        item.tapHandler = self.showMemoView
        return item
    }()

    var memoText: String = ""{
        didSet {
            memoItem?.value = memoText
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Appを保存"
        let viewController = navigationController?.viewControllers.first
        viewController?.navigationItem.rightBarButtonItem?.title = "保存"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Appかどうかの判定
        checkAppStore { [weak self] (isAppStore) in
            if !isAppStore {
                self?.showAlert()
            }
        }
    }

    // MARK: - Public method

    override func configurationItems() -> [Any]! {
        guard let labelItem = labelItem, let memoItem = memoItem else { return [] }
        let items: [SLComposeSheetConfigurationItem] = [labelItem, memoItem]
        return items
    }

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let extensionItem: NSExtensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProviders = extensionItem.attachments else { return }
        print(itemProviders)
        //        loadData(itemProviders: itemProviders)
    }

    // MARK: - Private Method

    private func showLabelList() {
        let labelListVC = LabelListTableViewController(style: .plain)
        labelListVC.delegate = self
        pushConfigurationViewController(labelListVC)
    }

    private func showMemoView() {
        let memoVC = MemoViewController()
        memoVC.delegate = self
        pushConfigurationViewController(memoVC)
    }

    private func checkAppStore(_ completion: @escaping (Bool) -> Void) {
        guard let extensionItem: NSExtensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProviders = extensionItem.attachments else {
                completion(false)
                return
        }
        guard let urlProvider = itemProviders.first(where: { $0.hasItemConformingToTypeIdentifier("public.url")}) else {
            completion(false)
            return
        }
        urlProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (item, _) in
            guard let url = item as? URL else {
                completion(false)
                return
            }
            let urlString = url.absoluteString
            completion(urlString.contains("apps.apple.com"))
        }
    }

    private func showAlert() {
        let alertController = UIAlertController(title: "利用できません", message: "この機能はAppStoreでのみ利用できます。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "了解", style: .destructive) { _ in
            self.cancel()
        })
        present(alertController, animated: true, completion: nil)
    }
    //
    //    func getImageData(completion:@escaping (UIImage) -> Void) {
    //        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
    //        // var bool = false
    //        guard let itemProviders = extensionItem.attachments else { return }
    //        for itemProvider in itemProviders {
    //            //IMAGE
    //            if itemProvider.hasItemConformingToTypeIdentifier("public.image") {
    //                itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil, completionHandler: { (item, error) in
    //
    //                    if let uiImage = item as? UIImage {
    //                        completion(uiImage)
    //                    } else if let imageURL = item as? URL {
    //                        do {
    //                            let imageData = try Data(contentsOf: imageURL)
    //                            completion(UIImage(data: imageData)!)
    //                        } catch {
    //                            print(error)
    //                        }
    //                    }
    //                })
    //            }
    //        }
    //    }
    //
    //    func isContainImage(_ completion:() -> Void) {
    //        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
    //        // var bool = false
    //        guard let itemProviders = extensionItem.attachments else { return }
    //        //print(itemProviders)
    //        if !itemProviders.contains(where: { (itemProvider) -> Bool in
    //            return itemProvider.hasItemConformingToTypeIdentifier("public.image") || itemProvider.hasItemConformingToTypeIdentifier("public.jpeg")
    //        }) {
    //            completion()
    //        }
    //    }
    //
    //    func showNoImageAlert() {
    //        //ポップアップを表示
    //        let alertController = UIAlertController(title: "利用できません", message: "現在画像を共有できる場合にのみ利用できます。", preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: "了解", style: .destructive) { _ in
    //            self.cancel()
    //        })
    //        present(alertController, animated: true, completion: nil)
    //    }
    //
    //    func showError() {
    //        let alertController = UIAlertController(title: "失敗", message: "保存に失敗しました。", preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: "了解", style: .destructive) { _ in
    //            self.cancel()
    //            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    //        })
    //        present(alertController, animated: true, completion: nil)
    //    }
    //
    //
    //    func loadData(itemProviders: [NSItemProvider]) {
    //        for itemProvider in itemProviders {
    //            print("itemProvider.registeredTypeIdentifiers\(itemProvider.registeredTypeIdentifiers)")
    //            //URL と ID
    //            if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
    //                getURL(itemProvider) //urlとidを取得
    //            }
    //
    //            //IMAGE
    //            if itemProvider.hasItemConformingToTypeIdentifier("public.image") {
    //                if image == nil {
    //                    getImage(itemProvider)
    //                } else {
    //                    self.saveItemCount += 1
    //                }
    //            }
    //
    //            //PLAIN-TEXT
    //            if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
    //                getName(itemProvider)
    //            }
    //        }
    //        if !itemProviders.contains(where: { (itemProvider) -> Bool in
    //            return itemProvider.hasItemConformingToTypeIdentifier("public.url")
    //        }) {
    //            self.id = UUID().uuidString + "ROUNDCORNER" + "noStore"
    //            self.saveItemCount += 2
    //        }
    //        if !itemProviders.contains(where: { (itemProvider) -> Bool in
    //            return itemProvider.hasItemConformingToTypeIdentifier("public.plain-text")
    //        }) {
    //            self.name = self.contentText
    //            self.developer = ""
    //            self.saveItemCount += 2
    //        }
    //    }
    //
    //    func getHeic(_ itemProvider: NSItemProvider) {
    //        itemProvider.loadItem(forTypeIdentifier: "public.heic", options: nil, completionHandler: { (item, error) in
    //            // item にUIImageが入っている
    //            if let uiImage = item as? UIImage {
    //                self.image = uiImage.pngData()
    //            } else if let imageURL = item as? URL {
    //                do {
    //                    let imageData = try Data(contentsOf: imageURL)
    //                    self.image = imageData
    //                } catch {
    //                    print(error)
    //                }
    //            }
    //
    //            self.saveItemCount += 1
    //        })
    //    }
    //
    //    func getImage(_ itemProvider: NSItemProvider) {
    //        itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil, completionHandler: { (item, error) in
    //            if let uiImage = item as? UIImage {
    //                self.image = uiImage.pngData()
    //            } else if let imageURL = item as? URL {
    //                do {
    //                    let imageData = try Data(contentsOf: imageURL)
    //                    self.image = imageData
    //                } catch {
    //                    print(error)
    //                }
    //            }
    //            self.saveItemCount += 1
    //        })
    //    }
    //
    //    func getName(_ itemProvider: NSItemProvider) {
    //        itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (item, _) in
    //            //ここは２回呼ばれる
    //            var text = item as! String
    //            if text.contains("App名") {
    //                let appLabelRange = text.range(of: "App名: ")
    //                let developLabelRange = text.range(of: "、デベロッパ: ")
    //
    //                //App名
    //                var nameString = text[..<developLabelRange!.lowerBound]
    //                nameString.removeSubrange(appLabelRange!)
    //                self.name = String(nameString)
    //
    //                //デベロッパ名
    //                let developString = text[developLabelRange!.upperBound ..< text.endIndex]
    //                self.developer = String(developString)
    //
    //                self.saveItemCount += 2
    //            } else if text.contains("」") && text.contains("「") {  //ios10以下用
    //                let developLabelRange = text.range(of: "「")
    //
    //                //デベロッパ名
    //                let developString = text[..<developLabelRange!.lowerBound]
    //                self.developer = String(developString)
    //                text.removeSubrange(..<developLabelRange!.lowerBound)
    //                text.removeFirst()
    //                text.removeLast()
    //                //app名
    //                let nameString: String = text
    //                self.name = String(nameString)
    //
    //                self.saveItemCount += 2
    //            } else if text.contains("by") {  // usStore
    //                let developLabelRange = text.range(of: "by")
    //
    //                //App名
    //                let nameString = text[..<developLabelRange!.lowerBound]
    //                self.name = String(nameString)
    //
    //                //デベロッパ名
    //                let developString = text[developLabelRange!.upperBound ..< text.endIndex]
    //                //print("develop\(developString)")
    //                self.developer = String(developString)
    //
    //                self.saveItemCount += 2
    //            } else {
    //                if text != "" {
    //                    self.saveItemCount += 2
    //                } else {
    //                    print("から文字だよ")
    //                }
    //            }
    //        })
    //    }
    //
    //    func getURL(_ itemProvider: NSItemProvider) {
    //        itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (item, _) in
    //
    //            self.url = (item as? URL)!.absoluteString
    //            if let idRange = self.url.range(of: "id"), let endIndex = self.url.firstIndex(of: "?") {
    //                self.id = String(self.url[idRange.lowerBound ..< endIndex])
    //            } else {
    //                self.id = UUID().uuidString + "ROUNDCORNER" + "noStore"
    //            }
    //            self.saveItemCount += 2
    //        })
    //    }
    //
    //    func contains(labelID: String, appID: String) -> Bool {
    //        var config = Realm.Configuration(schemaVersion: .schemaVersion)
    //        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
    //        config.fileURL = url.appendingPathComponent("db.realm")
    //
    //        let realm = try! Realm(configuration: config)
    //        guard realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: labelID) != nil else {
    //            return false
    //        }
    //        guard realm.object(ofType: AppRealmData.self, forPrimaryKey: appID) != nil else {
    //            return false
    //        }
    //        return true
    //    }

}

extension ShareViewController: MemoViewDelegate {
    var shareVC: ShareViewController {
        return self
    }
}

extension ShareViewController: LabelListTableViewControllerDelegate {}
