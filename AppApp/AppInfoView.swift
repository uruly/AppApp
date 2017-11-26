//
//  AppInfoView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class AppInfoView: UIView {

    var imageView:UIImageView!
    var appNameLabel:UILabel!
    
    var imageData:Data!
    var appName:String!
    var tableView:UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //setSubviews()
    }
    
    func setSubviews(){
        let margin:CGFloat = 15.0
        let width = self.frame.width
        let height = self.frame.height
        
        //イメージビューを配置
        imageView = UIImageView(frame:CGRect(x:margin,y:margin,width:width / 3,height:width / 3))
        imageView.image = UIImage(data:imageData)
        self.addSubview(imageView)
        
        //アプリ名を配置
        appNameLabel = UILabel(frame: CGRect(x:imageView.frame.maxX + margin,y:margin,width:width - imageView.frame.width - (margin * 2),height:200))
        appNameLabel.text = appName
        appNameLabel.numberOfLines = 0
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        appNameLabel.sizeToFit()
        self.addSubview(appNameLabel)
        
        tableView = UITableView(frame: CGRect(x:margin,y:imageView.frame.maxY + margin,
                                              width:width - (margin * 2 ),
                                              height:height - imageView.frame.maxY),
                                style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppInfo")
        self.addSubview(tableView)
        
    }

}

extension AppInfoView: UITableViewDelegate {
    
}
extension AppInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "基本情報"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfo", for: indexPath)
        cell.textLabel?.text = "にゃーん"
        return cell
    }
}
