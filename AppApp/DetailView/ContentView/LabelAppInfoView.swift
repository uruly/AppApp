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
        
    }
}

extension LabelAppInfoView:UITableViewDelegate {
    
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
            //memoView.detailVC = self.detailVC
            //memoView.isScrollEnabled = false
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
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if let text = textView.text{
            detailVC.memoText = text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.beginUpdates()
        self.endUpdates()
        
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        if let text = textView.text{
            detailVC.memoText = text
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
//
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

