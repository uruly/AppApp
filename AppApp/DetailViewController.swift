//
//  DetailViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/24.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var appData:ApplicationStruct!
    var scrollView:UIScrollView!
    var appInfoView:AppInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height

        self.view.backgroundColor = UIColor.backgroundGray()
        self.title = "アプリの情報"
        
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x:0,y:0,width:width,height:height)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        let naviBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 57.0
        let margin:CGFloat = 15.0
        appInfoView = AppInfoView(frame:CGRect(x:margin,y:margin,width:width - (margin * 2),height:height))
        appInfoView.appName = appData.app.name
        appInfoView.imageData = appData.app.image
        appInfoView.setSubviews()
        scrollView.addSubview(appInfoView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension DetailViewController: UIScrollViewDelegate {
    
}
