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
}

class LabelAppInfoView: UITableView {
    
    var memo:String = ""
    var memoView:UITextView!
    var detailVC:DetailViewController!
    //var widthLayout:CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: .grouped)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white
        self.isScrollEnabled = false
        self.register(UITableViewCell.self, forCellReuseIdentifier: "AppInfo")
        self.register(UINib(nibName:"MemoCell",bundle:nil), forCellReuseIdentifier: "MemoCell")
        self.estimatedRowHeight = 500
        self.rowHeight = UITableViewAutomaticDimension
        self.contentInset.bottom = 15
        print("awake")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.showKeyboard(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        print("remove")
    }
    override func reloadData() {
        super.reloadData()
        if detailVC != nil{
            detailVC.contentView.memoViewFrame = CGSize(width:detailVC.view.frame.width,height:200)
        }
    }
    
    @objc func showKeyboard(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardFrameInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                // キーボードの高さを取得
                print(keyboardFrameInfo.cgRectValue.height)
                let keyboardHeight = keyboardFrameInfo.cgRectValue.height
                let keyMinY = self.detailVC.view.frame.height - keyboardHeight
                if let range = memoView.selectedTextRange?.end{
                    let rect = memoView.caretRect(for:range)
                    print("rect\(rect)")
                    //このYがキーボードと被っているかどうかで判断をする
                    let scrollRect = memoView.convert(rect, to: self.detailVC.view)
                    let currentContentRect = memoView.convert(rect,to:self.detailVC.contentView)
                    print("contentRe\(currentContentRect)")
                    print("scrollRect.maxY\(scrollRect.maxY)")
                    print("min\(scrollRect.minY)")
                    print("keyMinY\(keyMinY)")
                    if scrollRect.minY >= keyMinY {
                        let diffY = scrollRect.minY - keyMinY
                        print(diffY)
                        //let currentContentOffsetY =
                        print("detailVC.contentView.contentOffset.y\(detailVC.contentView.contentOffset.y)")
                        // navigationbar の分が−64されて帰ってくる
                        detailVC.contentView.contentOffset.y += (diffY - (detailVC.navigationController?.navigationBar.frame.maxY ?? 0) )
                    }
                }
            }
        }
    }
    
}

extension LabelAppInfoView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
}
extension LabelAppInfoView:UITableViewDataSource {
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
            
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                DispatchQueue.main.async {
                    self.detailVC.contentView.memoViewFrame = CGSize(width:self.detailVC.view.frame.width,height:cell.memoView.contentSize.height + 70)
                    //print("このてーぶるよばれてる\(cell.memoView.bounds),\(size)")
                }
            })
            return cell
        }else {
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

extension LabelAppInfoView:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("はじめ\(textView.frame)")
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
        if let text = textView.text{
            detailVC.memoText = text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.beginUpdates()
        self.endUpdates()
        detailVC.contentView.memoViewFrame = CGSize(width:detailVC.view.frame.width,height:textView.frame.height + 70.0)
        
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        if let text = textView.text{
            detailVC.memoText = text
        }
        
        if let range = textView.selectedTextRange?.end{
            let rect = textView.caretRect(for:range)
            print(rect)
            //このYがキーボードと被っているかどうかで判断をする
            let scrollRect = textView.convert(rect, to: self.detailVC.view)
            print(scrollRect)
        }
    }
    
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
extension LabelAppInfoView:MemoDelegate {
    func scroll(){
        if memoView != nil{
            if let text = memoView.text , memoView.isFirstResponder{
                detailVC.memoText = text
            }
            _ = memoView.resignFirstResponder()
        }
    }
}

class MemoTextView:UITextView {
    var detailVC:DetailViewController!

    override func resignFirstResponder() -> Bool {
        if detailVC != nil {
            detailVC.saveAppLabelMemo(self.text)
        }
        return super.resignFirstResponder()
    }

    override var isScrollEnabled: Bool{
        didSet {
            print("setされたよ")
            print("isScrollEnabled")
        }
    }
}

