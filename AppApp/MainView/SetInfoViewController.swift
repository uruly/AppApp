//
//  SetInfoViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

class SetInfoViewController: UIViewController {

    var image: UIImage!
    var isEditView: Bool = false
    var tableView: InfoTableView!
    var imageView: EditImageView!
    var titleName: String! {
        didSet {
            if let doneBtn = self.navigationItem.rightBarButtonItem {
                if titleName == "" || creator == "" || creator == nil {
                    doneBtn.tintColor = UIColor.lightGray
                } else {
                    doneBtn.tintColor = nil
                }
            }
        }
    }
    var creator: String! {
        didSet {
            if let doneBtn = self.navigationItem.rightBarButtonItem {
                if titleName == "" || creator == "" || titleName == nil {
                    doneBtn.tintColor = UIColor.lightGray
                } else {
                    doneBtn.tintColor = nil
                }
            }
        }
    }
    var memo: String = ""
    //var url:URL?
    //var urlString:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height
        let doneBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.doneBtnTapped))
        self.navigationItem.rightBarButtonItem = doneBtn
        doneBtn.tintColor = UIColor.lightGray
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = UIColor.white

        let navigationHeight: CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 56.0
        //imageViewを置く
        let imageSize: CGFloat = 180
        imageView = EditImageView(frame: CGRect(x: 0, y: navigationHeight, width: imageSize, height: imageSize))
        imageView.center = CGPoint(x: width / 2, y: navigationHeight + imageSize / 2 + 30)

        //向き調整
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //レイヤーを足す
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        layer.contents = image.cgImage
        layer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        layer.name = "image"
        imageView.layer.addSublayer(layer)

        let shadowView = UIView(frame: imageView.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.cornerRadius = 40.0
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowOpacity = 0.5
        self.view.addSubview(shadowView)
        self.view.addSubview(imageView)

        //テーブルビューをおく
        tableView = InfoTableView(frame: CGRect(x: 0, y: imageView.frame.maxY + 15, width: width, height: height - ( imageView.frame.maxY + 15 )))
        tableView.infoDelegate = self
        self.view.addSubview(tableView)

        NotificationCenter.default.addObserver(
            tableView,
            selector: #selector(tableView.showKeyboard(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )

        //creatorがあれば
        creator = UserDefaults.standard.string(forKey: "creator") ?? ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editImageTutorial()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //print("disappear")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isEditView {
            if let vc = self.navigationController?.viewControllers, vc.count - 2 >= 0 {
                self.navigationController?.popToViewController(vc[vc.count - 2], animated: true)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func doneBtnTapped() {
        //print("memo\(memo),title\(titleName)")
        if let doneBtn = self.navigationItem.rightBarButtonItem, doneBtn.tintColor != nil {
            return
        }
        let id = UUID().uuidString + "ROUNDCORNER"
        let cropImage = imageView.snapshot()
        let imageData = cropImage.pngData()!
        saveAppData(name: titleName, developer: creator, id: id, urlString: "", image: imageData)
        //UIImageWriteToSavedPhotosAlbum(cropImage, self, nil, nil)  //ここいれたいけども
        self.dismiss(animated: true, completion: nil)
    }

    //AppのDataをセーブするよ
    func saveAppData(name: String, developer: String, id: String, urlString: String, image: Data) {
        var config =  Realm.Configuration(
            schemaVersion: .schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                //print(oldSchemaVersion)
                if oldSchemaVersion < 4 {
                    migration.enumerateObjects(ofType: AppRealmData.className()) { _, newObject in
                        //print("migration")

                        newObject!["urlString"] = ""
                    }
                    migration.enumerateObjects(ofType: AppLabelRealmData.className()) { _, newObject in
                        newObject!["explain"] = ""
                    }
                }
        })
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        Realm.Configuration.defaultConfiguration = config

        var date = Date()
        let realm = try! Realm()
        if let object = realm.object(ofType: AppRealmData.self, forPrimaryKey: id) {
            date = object.date
        }
        let appData = AppRealmData(value: ["name": name,
                                           "developer": developer,
                                           "id": id,
                                           "urlString": urlString,
                                           "image": image,
                                           "date": date])
        try! realm.write {
            realm.add(appData, update: .all)
        }
        saveLabelAppData(appData: appData)
    }

    //Appとラベルを紐づけたのを保存するよ
    func saveLabelAppData(appData: AppRealmData) {

        for label in tableView.checkArray {
            //print("label.name:\(label.name)")
            let colorData = NSKeyedArchiver.archivedData(withRootObject: label.color)
            let labelRealm = AppLabelRealmData(value: ["name": label.name,
                                                       "color": colorData,
                                                       "id": label.id,
                                                       "order": label.order
            ])
            let id = UUID().uuidString
            let order = self.dataCount(label: labelRealm)
            let realm = try! Realm()
            let data = ApplicationData(value: ["app": appData,
                                               "label": labelRealm,
                                               "id": id,
                                               "rate": 0,
                                               "order": order,
                                               "memo": memo])

            try! realm.write {
                realm.add(data, update: .all)
            }
            print("成功?")
        }
    }

    func dataCount(label: AppLabelRealmData) -> Int {
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)
        guard let labelData = realm.object(ofType: AppLabelRealmData.self, forPrimaryKey: label.id) else {
            return 0
        }

        let objs = realm.objects(ApplicationData.self).filter("label == %@", labelData)
        //print("objs.count\(objs.count)")
        return objs.count
    }

    func editImageTutorial() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "editImageTutorial") {
            let width = self.view.frame.width
            let rect = CGRect(x: 50, y: self.imageView.frame.maxY, width: width - 100, height: 80)
            let balloonView = BalloonView(frame: rect, color: UIColor.help())
            let fakeView = FakeView(frame: self.view.frame)
            self.view.addSubview(fakeView)
            balloonView.isDown = false
            balloonView.label.text = "ドラッグ・ピンチイン\nピンチアウトで調整"
            balloonView.label.textColor = UIColor.white
            fakeView.addSubview(balloonView)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseIn], animations: {
                balloonView.center.y += 5.0
            }, completion: nil)
            userDefaults.set(true, forKey: "editImageTutorial")
        }
    }
}

extension SetInfoViewController: InfoTableViewDelegate {
    var setVC: SetInfoViewController {
        return self
    }

}

//extension SetInfoViewController:UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        print("navigationController\(navigationController.viewControllers.count)")
//        if navigationController.viewControllers.count == 4 {
//
//        }
//    }
//}
