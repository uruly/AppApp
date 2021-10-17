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

extension Notification.Name {
    static let notificationLabels = Notification.Name("NotificationLabels")
}

class ShareViewController: SLComposeServiceViewController {

    var id: String?
    var name: String?
    var url: String = ""
    var developer = ""
    var image: Data?
    var labels: [Label] = [] {
        didSet {
            let names = labels.map { $0.name }
            labelItem?.value = names.joined(separator: ",")
        }
    }

    lazy var labelItem: SLComposeSheetConfigurationItem? = {
        guard let item = SLComposeSheetConfigurationItem() else {
            return nil
        }
        item.title = "ラベル"
        item.value = "ALL"
        item.tapHandler = self.showLabelList
        return item
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .fullScreen
        title = "Appを保存"
        let viewController = navigationController?.viewControllers.first
        viewController?.navigationItem.rightBarButtonItem?.title = "保存"

        // iOS13 で高さがおかしいのを修正する（おこ）
        if #available(iOS 13.0, *) {
            _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { (_) in
                if let layoutContainerView = self.view.subviews.last {
                    layoutContainerView.frame.size.height += 15
                }
            }
        }
        if let allLabel = Label.getAllLabel() {
            labels = [allLabel]
        }

        setupNotificationCenter()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Appかどうかの判定
        checkAppStore { [weak self] (isAppStore) in
            guard !isAppStore else { return }
            DispatchQueue.main.async {
                self?.showAlert()
            }
        }
        // 既に含んでいるかの判定
        checkAppDuplicated { [weak self] (isDuplicated) in
            guard isDuplicated else { return }
            DispatchQueue.main.async {
                let message = "このアプリは既に保存されています。"
                self?.showError(message: message)
            }
        }
    }

    // MARK: - Public method

    override func configurationItems() -> [Any]! {
        guard let labelItem = labelItem else { return [] }
        let items: [SLComposeSheetConfigurationItem] = [labelItem]
        return items
    }

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let extensionItem: NSExtensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProviders = extensionItem.attachments else { return }
        save(itemProviders: itemProviders) { [weak self] isSuccess in
            if isSuccess {
                self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            } else {
                let message = "保存に失敗しました。"
                self?.showError(message: message)
            }
        }
    }

    @objc func getLabels(notification: Notification) {
        guard let labels = notification.object as? [Label] else {
            fatalError("Labelじゃないよ")
        }
        self.labels = labels
    }

    // MARK: - Private Method

    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(getLabels(notification:)), name: .notificationLabels, object: nil)
    }

    private func showLabelList() {
        let viewController = LabelListTableViewController(style: .plain)
        viewController.selectedLabels = labels
        pushConfigurationViewController(viewController)
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

    private func checkAppDuplicated(_ completion: @escaping (Bool) -> Void) {
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
            let id = url.lastPathComponent
            let isContain = Label.isContain(appStoreID: id)
            completion(isContain)
        }
    }

    private func showAlert() {
        let alertController = UIAlertController(title: "利用できません", message: "この機能はAppStoreでのみ利用できます。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "了解", style: .destructive) { _ in
            self.cancel()
        })
        present(alertController, animated: true, completion: nil)
    }

    private func showError(message: String) {
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "了解", style: .destructive) { _ in
            self.cancel()
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        })
        present(alertController, animated: true, completion: nil)
    }

    private func save(itemProviders: [NSItemProvider], completion: @escaping (Bool) -> Void) {
        guard let urlProvider = itemProviders.first(where: { $0.hasItemConformingToTypeIdentifier("public.url")}) else {
            completion(false)
            return
        }
        urlProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] (item, _) in
            guard let wself = self, let url = item as? URL else {
                completion(false)
                return
            }
            let id = url.lastPathComponent
            wself.getImageData(itemProviders: itemProviders) { (data) in
                DispatchQueue.main.async {
                    let app = App(uid: UUID().uuidString, appStoreID: id, image: data, memo: wself.textView.text)
                    do {
                        try App.add(app)
                        for label in wself.labels {
                            try Label.update(label, app: app)
                        }
                        completion(true)
                    } catch {
                        print("error", error)
                        completion(false)
                    }
                }
            }
        }
    }

    private func getImageData(itemProviders: [NSItemProvider], completion: @escaping (Data?) -> Void) {
        guard let imageProvider = itemProviders.first(where: { $0.hasItemConformingToTypeIdentifier("public.image")}) else {
            completion(nil)
            return
        }
        imageProvider.loadItem(forTypeIdentifier: "public.image", options: nil) { (item, _) in
            guard let image = item as? UIImage else {
                completion(nil)
                return
            }
            let data = image.pngData()
            completion(data)
        }
    }
}
