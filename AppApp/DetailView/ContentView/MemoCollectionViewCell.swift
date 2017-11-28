//
//  MemoCollectionViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/28.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class MemoCollectionViewCell: UICollectionViewCell {

    var memo:String = ""
    var detailVC:DetailViewController!
    
    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var memoView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.white
        memoView.delegate = self
        memoView.text = memo
        memoView.placeholder = "ラベルごとにメモを残せます"
        widthLayout.constant = UIScreen.main.bounds.width - 60
    }

}
extension MemoCollectionViewCell:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if let text = textView.text{
            detailVC.memoText = text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        //self.beginUpdates()
        //self.endUpdates()
        detailVC.contentView.collectionViewLayout.invalidateLayout()
        
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
extension MemoCollectionViewCell:MemoDelegate {
    func scroll(){
        if memoView != nil{
            if let text = memoView.text , memoView.isFirstResponder{
                detailVC.memoText = text
            }
            _ = memoView.resignFirstResponder()
        }
    }
}
