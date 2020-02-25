//
//  CreateLabelViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import RealmSwift

class CreateLabelViewController: UITableViewController {

    var name: String!
    var colorView: UIView!
    var color: UIColor! {
        didSet {
            if colorView != nil {
                colorView.backgroundColor = color
            }
        }
    }
    var colorPickerView: ColorPicker!
    //var labelListVC:LabelListTableViewController!
    let pickerViewHeight: CGFloat = 200.0
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "createAppLabel")
        self.color = UIColor.yellow
        self.title = "ラベルを作成"

        if let parentView = self.navigationController?.parent?.view {
            let width = parentView.frame.width
            let height = parentView.frame.height

            //カラーピッカー
            colorPickerView = ColorPicker()
            colorPickerView.frame = CGRect(x: 0,
                                           y: height,
                                           width: width,
                                           height: pickerViewHeight)
            colorPickerView.setup()
            colorPickerView.delegate = self
            parentView.addSubview(colorPickerView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            var existsSelfInViewControllers = true
            for viewController in viewControllers where viewController == self {
                existsSelfInViewControllers = false
                break
            }

            if existsSelfInViewControllers {
                //print("前の画面に戻る処理が行われました")
                self.saveLabel()
            }
        }
        super.viewWillDisappear(animated)
    }

    override init(style: UITableView.Style) {
        super.init(style: style)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 1 {
            self.showColorPicker()
            if textField != nil {
                textField.resignFirstResponder()
            }
        }
        cell?.isSelected = false

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createAppLabel", for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        if indexPath.section == 0 {
            textField = UITextField(frame: cell.contentView.frame)
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0,
                                                      width: 15, height: cell.contentView.frame.height))
            textField.leftViewMode = UITextField.ViewMode.always
            textField.delegate = self
            textField.returnKeyType = .done
            //textField.viewWithTag(5)
            if indexPath.row == 0 {
                textField.placeholder = "ラベル名"
                textField.tag = 1
                textField.becomeFirstResponder()
                textField.addTarget(self, action: #selector(self.nameChanged(sender:)), for: .editingChanged)
                //self.currentTextField = textField
            }
            cell.contentView.addSubview(textField)
        }

        //カラーを表示
        if indexPath.section == 1 {
            cell.textLabel?.text = "カラー"
            colorView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            colorView.backgroundColor = self.color
            colorView.layer.cornerRadius = 10
            cell.accessoryView = colorView
        }

        return cell
    }

    @objc func nameChanged(sender: UITextField) {
        self.name = sender.text
    }

    @objc func saveLabel() {
        //print("ここ呼ばれてない？")
        if name != nil && name != "" && !self.contains(name: name) {
            //saveする
            save {
                //labelListVC.readLabelData()
                //self.navigationController?.popViewController(animated: true)
                LabelListTableViewController.isUnwindCreate = true
            }
        }
    }
    func save(_ completion:() -> Void) {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        let id = UUID().uuidString

        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)
        let order = realm.objects(AppLabelRealmData.self).count
        let label = AppLabelRealmData(value: ["name": name,
                                              "color": colorData,
                                              "id": id,
                                              "order": order
        ])
        try! realm.write {
            realm.add(label, update: .all)
        }
        completion()

    }

    func contains(name: String) -> Bool {
        var config = Realm.Configuration(schemaVersion: .schemaVersion)
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz.uruly.appapp")!
        config.fileURL = url.appendingPathComponent("db.realm")

        let realm = try! Realm(configuration: config)
        let objs = realm.objects(AppLabelRealmData.self)
        for obj in objs where obj.name == name {
            return true
        }
        return false
    }

    func showColorPicker() {
        if colorPickerView != nil {
            if let parentView = self.navigationController?.parent?.view {
                let width = parentView.frame.width
                let height = parentView.frame.height
                createFakeView(tag: 1)
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.colorPickerView.frame = CGRect(x: 0, y: height - 200, width: width, height: 200)
                }, completion: nil)
            }
        }
    }

    func createFakeView(tag: Int) {
        if let parentView = self.navigationController?.parent?.view {
            let width = parentView.frame.width
            let height = parentView.frame.height
            let fakeView = FakeView(frame: CGRect(x: 0, y: 0, width: width, height: height - pickerViewHeight))
            fakeView.delegate = self
            fakeView.pickerTag = tag
            parentView.addSubview(fakeView)
        }
    }

    func dismissPickerView(tag: Int) {
        self.closeColorPicker()
    }

    func closeColorPicker() {
        if let parentView = self.navigationController?.parent?.view {
            let width = parentView.frame.width
            let height = parentView.frame.height
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.colorPickerView.frame = CGRect(x: 0, y: height, width: width, height: 200)
            }, completion: nil)
        }
    }

}

extension CreateLabelViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //self.currentTextField = textField
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("end")
        name = textField.text
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension CreateLabelViewController: ColorDelegate {
    func pickedColor(color: UIColor, endState: Bool) {
        //print("color\(color)")
        self.color = color
    }
}
