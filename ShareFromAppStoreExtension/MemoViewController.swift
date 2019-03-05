//
//  MemoViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol MemoViewDelegate{
    var shareVC:ShareViewController { get }
}

class MemoViewController: UIViewController {
    
    var textView:UITextView!
    var delegate:MemoViewDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "メモ"

        let margin:CGFloat = 15.0
        
        textView = UITextView(frame: CGRect(x:margin,y:margin,
                                            width:self.view.bounds.width - (margin * 4),
                                            height:200))
        textView.becomeFirstResponder()
        textView.font = UIFont.systemFont(ofSize:UIFont.systemFontSize)
        textView.backgroundColor = UIColor.clear
        textView.delegate = self
        textView.text = delegate.shareVC.memoText
        self.view.addSubview(textView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MemoViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        //print(textView.text)
        delegate.shareVC.memoText = textView.text
    }
}
