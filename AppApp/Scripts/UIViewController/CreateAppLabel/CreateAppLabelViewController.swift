//
//  CreateAppLabelViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class CreateAppLabelViewController: UIViewController {

    //var naviBar:CustomNavigationBar!
    var tableView: CreateAppLabelTableView!
    var pickerView: LabelOrderPickerView!
    var isResetOrder = false
    //var currentRow:Int = AppLabel.count ?? 0
    var pickerViewHeight: CGFloat = 200.0

    var labelName: String? {
        didSet {
            if labelName != "" && labelName != nil {
                //すでにあったらno
                if !AppLabel.contains(name: labelName!) {
                    if let rightItem = self.navigationItem.rightBarButtonItem {
                        rightItem.tintColor = nil
                    }
                } else {
                    if let rightItem = self.navigationItem.rightBarButtonItem {
                        rightItem.tintColor = UIColor.lightGray
                    }
                    //ポップアップで重複を知らせる
                }
            } else {
                if let rightItem = self.navigationItem.rightBarButtonItem {
                    rightItem.tintColor = UIColor.lightGray
                }
            }
        }
    }
    var order: Int = AppLabel.count ?? 1 {
        didSet {
            if tableView == nil {
                return
            }
            var text = "\(order)番目に追加"
            if order == AppLabel.count {
                text = "最後に追加"
            }
            tableView.orderLabel.text = text
        }
    }

    var color: UIColor = UIColor(red: CGFloat(arc4random_uniform(254)) / 255, green: CGFloat(arc4random_uniform(254) ) / 255, blue: CGFloat(arc4random_uniform(254) ) / 255, alpha: 1) {
        didSet {
            if tableView == nil {
                return
            }
            tableView.colorView.backgroundColor = color
        }
    }

    var explain: String?

    var appList: [AppRealmData] = []

    //var colorPickerView:ColorPicker!
    var colorPickView: ColorBaseView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = R.color.whiteFlowerColor()!

        //ナビゲーションバーを設置
        //let naviBarHeight = UIApplication.shared.statusBarFrame.height + 47.0
        //print(naviBarHeight)
        //naviBar = CustomNavigationBar(frame: CGRect(x:0,y:0,width:width,height:naviBarHeight))
        self.title = "ラベルを追加"
        let cancelBtn = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(self.cancelBtnTapped))
        let saveBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.saveBtnTapped(sender:)))
        saveBtn.tintColor = UIColor.lightGray    //まだ押せない
        self.navigationItem.leftBarButtonItem = cancelBtn
        self.navigationItem.rightBarButtonItem = saveBtn
        setTableView()

        //カラーピッカー
        //        colorPickerView = ColorPicker()
        //        colorPickerView.frame = CGRect(x:0,
        //                                       y:height,
        //                                       width:width,
        //                                       height:pickerViewHeight)
        //        colorPickerView.setup()
        //        colorPickerView.delegate = self
        //        self.view.addSubview(colorPickerView)

        colorPickView = ColorBaseView(frame: CGRect(x: 0, y: height, width: width, height: pickerViewHeight + 50))
        colorPickView.createAppLabelVC = self
        //colorPickView.colorDelegate = self
        self.view.addSubview(colorPickView)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            let bottomMargin = self.view.safeAreaInsets.bottom
            if bottomMargin != 0 {
                self.pickerViewHeight = 200.0 + bottomMargin
            }
        }
    }

    func setTableView() {
        //tableViewを設置
        let width = self.view.frame.width
        let height = self.view.frame.height
        let naviBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 57.0
        tableView = CreateAppLabelTableView(frame: CGRect(x: 0, y: naviBarHeight,
                                                          width: width,
                                                          height: height - naviBarHeight),
                                            createAppLabelVC: self)
        self.view.addSubview(tableView)

        //ピッカービュー
        pickerView = LabelOrderPickerView(frame: CGRect(x: 0, y: height, width: width, height: pickerViewHeight))
        pickerView.orderDelegate = self
        self.view.addSubview(pickerView)
    }

    @objc func cancelBtnTapped() {
        if tableView != nil {
            if let textField = tableView.currentTextField {
                textField.resignFirstResponder()
            }
            if let textView = tableView.memoView {
                textView.resignFirstResponder()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func saveBtnTapped(sender: UIBarButtonItem) {
        if tableView != nil {
            if let textField = tableView.currentTextField {
                textField.resignFirstResponder()
            }
            if let textView = tableView.memoView {
                textView.resignFirstResponder()
            }
        }
        if sender.tintColor != nil {
            return
        }
        //同じ色がすでに含まれていたらポップアップで確認を取る
        self.checkColor(color)

    }

    func checkColor(_ color: UIColor) {
        if AppLabel.contains(color: color, isEdit: false, id: "") {
            //ポップアップを表示
            let alertController = UIAlertController(title: "この色はすでに使われています", message: "", preferredStyle: .alert)
            let otherAction = UIAlertAction(title: "このまま保存する", style: .default) { _ in
                self.saveLabelData()
            }
            let cancelAction = UIAlertAction(title: "修正する", style: .cancel)

            alertController.addAction(otherAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        } else {
            self.saveLabelData()
        }
    }

    func createFakeView(tag: Int) {
        let width = self.view.frame.width
        let height = self.view.frame.height
        let fakeViewHeight = tag == 1 ? height - ( pickerViewHeight + 50 ) : height - pickerViewHeight
        let fakeView = FakeView(frame: CGRect(x: 0, y: 0, width: width, height: fakeViewHeight))
        fakeView.delegate = self
        fakeView.pickerTag = tag
        fakeView.tag = 66
        self.view.addSubview(fakeView)
    }

    func dismissPickerView(tag: Int) {
        //print("dis\(tag)")
        if tag == 1 {   //カラーピッカーを閉じる
            self.closeColorPicker()
        } else { //pickerViewを閉じる
            self.closePicker()
        }
    }
    func saveLabelData() {
        //セーブをする
        let id = NSUUID().uuidString
        AppLabel.saveLabelData(name: labelName!, color: color, id: id, order: order, explain: explain) {
            //
            AppData.saveAppData(appList: appList, labelID: id) {
                BasePageViewController.isUnwind = true
                self.dismiss(animated: true, completion: nil)
            }
        }

    }

    func showColorPicker() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        createFakeView(tag: 1)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.colorPickView.frame = CGRect(x: 0, y: height - ( self.pickerViewHeight + 50), width: width, height: self.pickerViewHeight + 50)
        }, completion: nil)
    }

    func closeColorPicker() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.colorPickView.frame = CGRect(x: 0, y: height, width: width, height: self.pickerViewHeight + 50)
        }, completion: nil)
    }
    func closePicker() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.pickerView.frame = CGRect(x: 0, y: height, width: width, height: 200)
        }, completion: nil)
    }

    func showPicker() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        self.pickerView.selectRow(order, inComponent: 0, animated: false)
        createFakeView(tag: 2)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.pickerView.frame = CGRect(x: 0, y: height - 200, width: width, height: 200)
        }, completion: nil)
    }

    func showAppList() {
        let appListVC = AppListViewController()
        //print("koko")
        appListVC.createAppLabelVC = self
        self.navigationController?.pushViewController(appListVC, animated: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CreateAppLabelViewController: ColorDelegate {
    func setColor(color: UIColor) {
        self.color = color
    }

    //    func pickedColor(color:UIColor,endState:Bool){
    //        print("color\(color)")
    //        self.color = color
    //    }
}
extension CreateAppLabelViewController: LabelOrderPickerDelegate {
    func changedValue(_ order: Int) {
        //orderLabel.text = text
        //print("changed\(order)")
        self.order = order
    }
}
