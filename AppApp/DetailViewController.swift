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
    var commonInfoView:CommonInfoView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height

        self.view.backgroundColor = UIColor.backgroundGray()
        self.title = appData.label.name
        
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x:0,y:0,width:width,height:height)
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        let naviBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 57.0
        let margin:CGFloat = 15.0
        appInfoView = AppInfoView(frame:CGRect(x:margin,y:margin,width:width - (margin * 2),height:180))
        appInfoView.appName = appData.app.name
        appInfoView.imageData = appData.app.image
        appInfoView.setSubviews()
        scrollView.addSubview(appInfoView)
        
        commonInfoView = CommonInfoView(frame: CGRect(x:margin,y:appInfoView.frame.maxY + margin,
                                              width:width - (margin * 2 ),
                                              height:200),
                                style: .grouped)
        commonInfoView.developerName = appData.app.developer
        commonInfoView.id = appData.app.id
        commonInfoView.saveDate = convertDate(appData.app.date)
        scrollView.addSubview(commonInfoView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertDate(_ date:Date) -> String {
        let component = Calendar.current.dateComponents([.year,.month,.day], from: date)
        let text = "\(component.year!)年\(component.month!)月\(component.day!)日"
        return text
        
    }
    

}

extension DetailViewController: UIScrollViewDelegate {
    
}
