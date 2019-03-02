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
    var currentTag:Int?
    var links:[(String,String,String,String)] = [("このアプリのレビューを投稿する","いつもご利用ありがとうございます。以下のボタンよりレビューページへ飛ぶことができます。","レビューページへ","https://itunes.apple.com/us/app/itunes-u/id\(APPLE_ID)?action=write-review"),("お問い合わせをする","何かご意見・ご要望・感想等ありましたら、以下のボタンより、開発者サイトに飛ぶことができます。お気軽にご連絡ください。","開発者サイトへ","http://uruly.xyz/contact/")]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName:"HelpViewCell",bundle:nil), forCellReuseIdentifier: "help")
        self.register(UINib(nibName:"HelpLinkCell",bundle:nil), forCellReuseIdentifier: "helpLink")
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
            //print(header.tag)
            //itemSizeをかえてアコーディオンさせる
            if self.currentTag == header.tag {
                self.currentTag = nil
                self.beginUpdates()
                self.endUpdates()
            }else {
                self.currentTag = header.tag
                self.beginUpdates()
                self.endUpdates()
            }
        }
    }
    
    @objc func linkBtnTapped(sender:UIButton){
        let urlString = links[sender.tag].3
        if let url = URL(string: urlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.openURL(url)
                }
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
        if indexPath.section < questionAnswer.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "help", for: indexPath) as! HelpViewCell
            cell.answerLabel.text = questionAnswer[indexPath.section].1
            if let imagePath = Bundle.main.path(forResource: questionAnswer[indexPath.section].2, ofType: "png") {
                cell.explainImageView.image = UIImage(contentsOfFile:imagePath)
            }else {
                cell.explainImageView.image = nil
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "helpLink", for: indexPath) as! HelpLinkCell
            let index = indexPath.section - ( questionAnswer.count)
            if index >= 0 {
                cell.answerLabel.text = links[index].1
                cell.linkBtn.setTitle(links[index].2, for: .normal)
                cell.linkBtn.tag = index
                cell.linkBtn.addTarget(self, action: #selector(self.linkBtnTapped(sender:)), for: .touchUpInside)
            }
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionAnswer.count + links.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var text = ""
        if section < questionAnswer.count {
            text = questionAnswer[section].0
        }else {
            //print(section - ( questionAnswer.count - 1))
            if section - ( questionAnswer.count) >= 0 {
                text = links[section - ( questionAnswer.count)].0
            }
        }
        let view = UIView(frame:CGRect(x:0,y:0,width:tableView.frame.width,height:60))
        view.backgroundColor = UIColor.help()
        view.tag = section
        //タップジェスチャを登録 //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        let margin:CGFloat = 15
        let label = UILabel(frame:CGRect(x:margin,y:0,width:view.frame.width - (margin * 2),height:60))
        label.text = text
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label)
        
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == questionAnswer.count + links.count - 1{
            return 100
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == questionAnswer.count + links.count - 1{
            let view = UIView(frame:CGRect(x:0,y:0,width:self.frame.width,height:100))
            view.backgroundColor = UIColor.help()
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == currentTag {
            if indexPath.section < questionAnswer.count {
                if let _ = Bundle.main.path(forResource: questionAnswer[indexPath.section].2, ofType: "png") {
                    return 300
                }else {
                    return 150
                }
            }else {
                return 180
            }
        }else {
            return 0
        }
    }

}
