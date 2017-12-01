//
//  HelpView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class HelpView: UITableView {
    
    var questionAnswer:[(String,String,String)] = []
    var currentTag:Int = 100

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "help")
        self.backgroundColor = UIColor.help()
        self.separatorColor = UIColor.white
        self.sectionFooterHeight = 1
    }
    
    func setup(){
        
    }
    
    override func reloadData() {
        readHelp()
        super.reloadData()
    }
    
    func readHelp(){
        self.questionAnswer = []
        let path = Bundle.main.path(forResource: "help", ofType: "json")
        do {
            let jsonString = try String(contentsOfFile: path!)
            let colorData: Data =  jsonString.data(using: String.Encoding.utf8)!
            do {
                let json = try JSONSerialization.jsonObject(with: colorData, options: JSONSerialization.ReadingOptions.allowFragments)
                let top = json as! NSArray
                for object in top {
                    let set = object as! NSDictionary
                    guard let question = set["質問"] as? String else {
                        continue
                    }
                    guard let answer = set["答え"] as? String else {
                        continue
                    }
                    guard let id = set["id"] as? String else {
                        continue
                    }
                    self.questionAnswer.append((question,answer,id))
                    
                }
            } catch {
                print(error)
            }
        }catch {
            print(error)
        }
    }
    
    @objc func sectionTapped(sender:UITapGestureRecognizer){
        if let header = sender.view{
            print(header.tag)
            //itemSizeをかえてアコーディオンさせる
            if self.currentTag == header.tag {
                self.currentTag = 100
                self.beginUpdates()
                self.endUpdates()
            }else {
                self.currentTag = header.tag
                self.beginUpdates()
                self.endUpdates()
            }
        }
    }

}

extension HelpView: UITableViewDelegate {
    
}

extension HelpView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "help", for: indexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionAnswer.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect(x:0,y:0,width:tableView.frame.width,height:60))
        view.backgroundColor = UIColor.help()
        view.tag = section
        //タップジェスチャを登録 //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        let margin:CGFloat = 15
        let label = UILabel(frame:CGRect(x:margin,y:0,width:view.frame.width - (margin * 2),height:60))
        label.text = questionAnswer[section].0
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label)
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == currentTag {
            return 100
        }else {
            return 0
        }
    }

}
