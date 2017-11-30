//
//  ColorPageView.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol ColorPageControlDelegate {
    func movePage(count:Int)
}

enum ColorMode {
    case set
    case custom
}

class ColorPageView: UICollectionView {

    var colors:[UIColor] = [UIColor.purple,UIColor.blue,UIColor.brown,UIColor.yellow,UIColor.red]
    var colorPageDelegate:ColorPageControlDelegate!
    var colorDelegate:ColorDelegate!
    var colorMode:ColorMode = .set {
        didSet{
            self.reloadData()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(UINib(nibName:"ColorBaseCell",bundle:nil), forCellWithReuseIdentifier: "base")
        self.register(UINib(nibName:"RGBSliderCell",bundle:nil), forCellWithReuseIdentifier: "customBase")
        self.delegate = self
        self.dataSource = self
    }
    
    convenience init(frame: CGRect){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:frame.width,height:frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.init(frame: frame, collectionViewLayout: layout)
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.appStoreBlue()
        readColorSet()
    }
    
    func readColorSet(){
        let path = Bundle.main.path(forResource: "colorData", ofType: "json")
        do {
            let jsonString = try String(contentsOfFile: path!)
            let colorData: Data =  jsonString.data(using: String.Encoding.utf8)!
            do {
                let json = try JSONSerialization.jsonObject(with: colorData, options: JSONSerialization.ReadingOptions.allowFragments)
                let top = json as! NSArray
                for object in top {
                    print(object)
                }
//                for roop in top {
//                    let next = roop as! NSDictionary
//                    print(next["id"] as! String) // 1, 2 が表示
//
//                    let content = next["content"] as! NSDictionary
//                    print(content["age"] as! Int) // 25, 20 が表示
//                }
            } catch {
                print(error)
            }
        }catch {
            print(error)
        }
//        do{
//            //https://www.hackingwithswift.com/example-code/strings/how-to-load-a-string-from-a-file-in-your-bundle
//            let jsonStr = try String(contentsOfFile: path!)
//            let json =  JSON.parse(jsonStr)
//            return json
//        } catch{
//            return nil
//        }
    }
    
}

extension ColorPageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = false
    }
}

extension ColorPageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if colorMode == .set {  //ページ数
            return colors.count
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if colorMode == .set {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "base", for: indexPath) as! ColorBaseCell
            //cell.backgroundColor = colors[indexPath.row]
            cell.colorSetView.colorSet = [colors[indexPath.row]]
            print(colorDelegate)
            cell.colorSetView.colorDelegate = colorDelegate
            cell.colorSetView.reloadData()
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customBase", for: indexPath) as! RGBSliderCell
            cell.sliderView.colorDelegate = colorDelegate
            print(colorDelegate)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        colorPageDelegate.movePage(count:indexPath.row)
    }
}
