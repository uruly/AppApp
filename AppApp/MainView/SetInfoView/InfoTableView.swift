//
//  InfoTableView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit
@objc protocol InfoTableViewDelegate {
    var setVC:SetInfoViewController { get }
}

class InfoTableView: UITableView {
    
    var labelArray:[AppLabelData] = []
    var checkArray:[AppLabelData] = []
    var infoDelegate:InfoTableViewDelegate?
    var memoText = "" {
        didSet {
            if let setVC = infoDelegate?.setVC {
                setVC.memo = memoText
            }
        }
    }
    var commonTextArray = ["タイトル","作成者"]
    var commonPlaceholderArray = ["タイトルを記入","作成者を記入"]
    var keyboardHeight:CGFloat = 0
    var memoView:UITextView! {
        didSet {
            setDoneBtn(memoView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.register(UINib(nibName:"InfoTableViewCell",bundle:nil), forCellReuseIdentifier: "common")
        self.register(UITableViewCell.self, forCellReuseIdentifier: "label")
        self.register(UINib(nibName:"MemoCell",bundle:nil), forCellReuseIdentifier: "memo")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        
        let appLabel = AppLabel()
        labelArray = appLabel.array
        if labelArray.count > 0 {   //all入れておく
            checkArray.append(labelArray[0])
        }
        self.estimatedRowHeight = 500
        self.rowHeight = UITableViewAutomaticDimension
    }
    
    convenience init(frame:CGRect){
        self.init(frame:frame,style:.grouped)
    }
    
    @objc func showKeyboard(notification: Notification) {
        print("show")
        if let userInfo = notification.userInfo {
            if let keyboardFrameInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                // キーボードの高さを取得
                //print(keyboardFrameInfo.cgRectValue.height)
                let keyboardHeight = keyboardFrameInfo.cgRectValue.height
                self.keyboardHeight = keyboardHeight
                let keyMinY = self.superview!.frame.height - keyboardHeight
                if let range = memoView.selectedTextRange?.start{
                    let rect = memoView.caretRect(for:range)
                    let scrollRect = memoView.convert(rect, to: self.superview!)
                    if scrollRect.maxY >= keyMinY {
                        let diffY = scrollRect.maxY - keyMinY
                        UIView.animate(withDuration: 0.2, animations: {
                            self.contentOffset.y += diffY
                        })
                    }
                }
            }
        }
    }
    
    func setDoneBtn(_ memoView:UITextView){
        // 仮のサイズでツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = .default  // スタイルを設定
        toolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneBtnTapped(sender:)))
        toolBar.items = [spacer, commitButton]
        
        
        memoView.inputAccessoryView = toolBar
    }
    
    @objc func doneBtnTapped(sender:UIBarButtonItem){
        memoView.resignFirstResponder()
    }

}

extension InfoTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        cell.isSelected = false
        cell.isHighlighted = false
        if let selectRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectRow, animated: false)
        }
        
        if indexPath.section == 2 {
            let indexArray = checkArray.findIndex(includeElement: { (data) -> Bool in
                return data.name == ( cell.textLabel?.text ?? "" )
            })
            if indexArray.count > 0{
                if checkArray[indexArray[0]].name == "ALL" {
                    return
                }
                //外す
                checkArray.remove(at:indexArray[0])
                cell.accessoryType = .none
            }else {
                //つける
                checkArray.append(labelArray[indexPath.row])
                cell.accessoryType = .checkmark
            }
        }
    }
    
    @objc func textFieldChangedValue(sender:UITextField){
        if let setVC = infoDelegate?.setVC {
            if sender.tag == 0 {
                setVC.titleName = sender.text
            }
            if sender.tag == 1 {
                setVC.creator = sender.text
                UserDefaults.standard.set(sender.text, forKey: "creator")
            }
        }
    }
}

extension InfoTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return commonTextArray.count
        case 1: return 1
        case 2: return labelArray.count   //ここは可変がgoodかも
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "common", for: indexPath) as! InfoTableViewCell
            cell.nameLabel.text = commonTextArray[indexPath.row]
            cell.textField.placeholder = commonPlaceholderArray[indexPath.row]
            cell.textField.delegate = self
            cell.textField.addTarget(self, action: #selector(textFieldChangedValue(sender:)), for: .editingChanged)
            cell.textField.tag = indexPath.row
            if indexPath.row == 1 { //クリエイター名を入れる
                if let creator = UserDefaults.standard.string(forKey: "creator") {
                    cell.textField.text = creator
                }
            }
            return cell
        }else if indexPath.section == 1 {
            let cell:MemoCell = tableView.dequeueReusableCell(withIdentifier: "memo", for: indexPath) as! MemoCell
            cell.memoView.placeholder = "ここにメモを記入します。"
            cell.memoView.font = UIFont.systemFont(ofSize: 14)
            cell.memoView.delegate = self
            self.memoView = cell.memoView
            if let placeholderLabel = cell.memoView.viewWithTag(100) as? UILabel {
                placeholderLabel.font = UIFont.systemFont(ofSize:14)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "label", for: indexPath)
            cell.isSelected = false
            cell.isHighlighted = false
            cell.textLabel?.text = labelArray[indexPath.row].name
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            if checkArray.contains(where: { (data) -> Bool in
                return data.name == labelArray[indexPath.row].name
            }){
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //基本情報、メモ、つけるラベル
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.tableHeaderView?.backgroundColor = UIColor.white
        self.tableFooterView?.backgroundColor = UIColor.white
        switch section {
        case 0:
            return "基本情報"
        case 1:
            return "メモ"
        case 2:
            return "ラベル"
        default: return ""
        }
    }
    
}

extension InfoTableView:UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if let text = textView.text{
            self.memoText = text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.beginUpdates()
        self.endUpdates()
        //detailVC.contentView.memoViewFrame = CGSize(width:detailVC.view.frame.width,height:textView.frame.height + 70.0)
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        if let text = textView.text{
            self.memoText = text
        }
        
        //カーソルがキーボードと被ってないかチェック
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            DispatchQueue.main.async {
                let keyMinY = self.superview!.frame.height - self.keyboardHeight
                if let range = textView.selectedTextRange?.start{
                    let rect = textView.caretRect(for:range)
                    let scrollRect = textView.convert(rect, to: self.superview!)
                    //print("scrollRect\(scrollRect),keyMinY\(keyMinY)")
                    if scrollRect.maxY >= keyMinY {
                        let diffY = scrollRect.maxY - keyMinY
                        UIView.animate(withDuration: 0.2, animations: {
                            print("ここ呼ばれているよ")
                            self.contentOffset.y += diffY + 15
                        })
                    }
                }
            }
        })
    }
    
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

extension InfoTableView:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if let setVC = infoDelegate?.setVC {
            if textField.tag == 0 {
                setVC.titleName = textField.text
            }
            if textField.tag == 1 {
                setVC.creator = textField.text
            }
        }
    }
}

