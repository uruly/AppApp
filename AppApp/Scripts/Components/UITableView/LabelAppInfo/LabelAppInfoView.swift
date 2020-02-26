//
//  LabelAppInfoView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol MemoDelegate {
    func scroll()
    var labelAppInfoView: LabelAppInfoView { get }
}

class LabelAppInfoView: UITableView {

    var memo: String = ""
    var memoView: UITextView!
    var detailVC: DetailViewController!
    //var widthLayout:CGFloat!
    var keyboardHeight: CGFloat = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.isScrollEnabled = false
        self.register(UITableViewCell.self, forCellReuseIdentifier: "AppInfo")
        self.register(UINib(nibName: "MemoCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
        self.estimatedRowHeight = 500
        self.rowHeight = UITableView.automaticDimension
        self.contentInset.bottom = 15
        //print("awake")

    }

    override func reloadData() {
        super.reloadData()
        if detailVC != nil {
            detailVC.contentView.memoViewFrame = CGSize(width: detailVC.view.frame.width, height: 200)
        }
    }

    @objc func showKeyboard(notification: Notification) {

        if let userInfo = notification.userInfo {
            if let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                // キーボードの高さを取得
                //print(keyboardFrameInfo.cgRectValue.height)
                let keyboardHeight = keyboardFrameInfo.cgRectValue.height
                self.keyboardHeight = keyboardHeight
                let keyMinY = self.detailVC.view.frame.height - keyboardHeight
                if let range = memoView.selectedTextRange?.start {
                    let rect = memoView.caretRect(for: range)
                    let scrollRect = memoView.convert(rect, to: self.detailVC.view)
                    if scrollRect.maxY >= keyMinY {
                        let diffY = scrollRect.maxY - keyMinY
                        UIView.animate(withDuration: 0.2, animations: {
                            self.detailVC.contentView.contentOffset.y += diffY + 70.0
                        })
                    }
                }
            }
        }
    }

    @objc func dismissKeyboard(notification: Notification) {
    }

    func setDoneBtn(memoView: UITextView) {
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

    @objc func doneBtnTapped(sender: UIBarButtonItem) {
        memoView.resignFirstResponder()
    }

}

extension LabelAppInfoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
extension LabelAppInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
            cell.memoView.delegate = self
            cell.memoView.text = memo
            cell.memoView.placeholder = "ラベルごとにメモを残せます"
            memoView = cell.memoView
            if let placeholderLabel = cell.memoView.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = cell.memoView.text.count > 0
            }
            setDoneBtn(memoView: cell.memoView)

            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                DispatchQueue.main.async {
                    self.detailVC.contentView.memoViewFrame = CGSize(width: self.detailVC.view.frame.width, height: cell.memoView.contentSize.height + 70)
                    //print("このてーぶるよばれてる\(cell.memoView.bounds),\(size)")
                }
            })
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfo", for: indexPath)

            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "このラベルに関するメモ"
        }
        return ""
    }
}

extension LabelAppInfoView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        //print("はじめ\(textView.frame)")
        //        if let range = textView.selectedTextRange?.end{
        //            let rect = textView.caretRect(for:range)
        //            print(rect)
        //            //このYがキーボードと被っているかどうかで判断をする
        //            let scrollRect = textView.convert(rect, to: self.detailVC.view)
        //            print(scrollRect)
        //        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if let text = textView.text {
            detailVC.memoText = text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.beginUpdates()
        self.endUpdates()
        detailVC.contentView.memoViewFrame = CGSize(width: detailVC.view.frame.width, height: textView.frame.height + 70.0)
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        if let text = textView.text {
            detailVC.memoText = text
        }

        //カーソルがキーボードと被ってないかチェック
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            DispatchQueue.main.async {
                let keyMinY = self.detailVC.view.frame.height - self.keyboardHeight
                if let range = textView.selectedTextRange?.start {
                    let rect = textView.caretRect(for: range)
                    let scrollRect = textView.convert(rect, to: self.detailVC.view)
                    //print("scrollRect\(scrollRect),keyMinY\(keyMinY)")
                    if scrollRect.maxY >= keyMinY {
                        let diffY = scrollRect.maxY - keyMinY
                        UIView.animate(withDuration: 0.2, animations: {
                            //print("ここ呼ばれているよ")
                            self.detailVC.contentView.contentOffset.y += diffY + 70
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
extension LabelAppInfoView: MemoDelegate {
    func scroll() {
        if memoView != nil {
            if let text = memoView.text, memoView.isFirstResponder {
                detailVC.memoText = text
            }
            _ = memoView.resignFirstResponder()
        }
    }
    var labelAppInfoView: LabelAppInfoView {
        return self
    }
}

//class MemoTextView:UITextView {
//    var detailVC:DetailViewController!
//
//    override func resignFirstResponder() -> Bool {
//        if detailVC != nil {
//            detailVC.saveAppLabelMemo(self.text)
//        }
//        return super.resignFirstResponder()
//    }
//
//    override var isScrollEnabled: Bool{
//        didSet {
//            print("setされたよ")
//            print("isScrollEnabled")
//        }
//    }
//}
