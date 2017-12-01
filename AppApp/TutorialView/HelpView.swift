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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.delegate = self
        self.dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "help")
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return questionAnswer[section].0
    }
    

}
