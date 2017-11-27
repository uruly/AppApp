//
//  WebViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var searchWord:String = ""
    var webView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.backgroundGray()
        
        webView = WKWebView(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height))
        
        //
        webView.allowsBackForwardNavigationGestures = true
        
        let urlString = "https://www.google.co.jp/search?&q=\(searchWord)"
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        let url = NSURL(string: encodedUrlString!)
        let request = NSURLRequest(url: url! as URL)
        webView.load(request as URLRequest)
        
        self.view.addSubview(webView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
