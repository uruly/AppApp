//
//  ColorPageView.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol ColorPageControlDelegate {
    func movePage(count: Int)
    var basePageView: ColorBaseView { get }
}

enum ColorMode {
    case set
    case custom
}

class ColorPageView: UICollectionView {

    //var colors:[UIColor] = [UIColor.purple,UIColor.blue,UIColor.brown,UIColor.yellow,UIColor.red]
    weak var colorPageDelegate: ColorPageControlDelegate!
    weak var colorDelegate: ColorDelegate!
    var colorMode: ColorMode = .set {
        didSet {
            self.reloadData()
        }
    }

    var colorSet: [String: [UIColor]] = [:]
    var colorKeys: [String] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(UINib(nibName: "ColorBaseCell", bundle: nil), forCellWithReuseIdentifier: "base")
        self.register(UINib(nibName: "RGBSliderCell", bundle: nil), forCellWithReuseIdentifier: "customBase")
        self.delegate = self
        self.dataSource = self
    }

    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        self.init(frame: frame, collectionViewLayout: layout)
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.appStoreBlue()
    }

    override func reloadData() {
        if colorMode == .set {
            readColorSet()
            if colorPageDelegate != nil {
                colorPageDelegate.basePageView.pageControl.numberOfPages = self.colorSet.keys.count
            }
            super.reloadData()
        } else {
            super.reloadData()
        }
    }

    func readColorSet() {
        self.colorSet = [:]
        self.colorKeys = []
        let path = Bundle.main.path(forResource: "colorData", ofType: "json")
        do {
            let jsonString = try String(contentsOfFile: path!)
            let colorData: Data =  jsonString.data(using: String.Encoding.utf8)!
            do {
                let json = try JSONSerialization.jsonObject(with: colorData, options: JSONSerialization.ReadingOptions.allowFragments)
                let top = json as! NSArray
                for object in top {
                    //print(object)
                    let set = object as! NSDictionary
                    //print(set["セット名"])
                    guard let setName = set["セット名"] as? String else {
                        continue
                    }
                    self.colorSet[setName] = []
                    self.colorKeys.append(setName)
                    let colors = set["カラー"] as! NSArray
                    for col in colors {
                        let color = col as! NSDictionary
                        let red = color["red"] as! Int
                        let green = color["green"] as! Int
                        let blue = color["blue"] as! Int
                        let uiColor = UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
                        self.colorSet[setName]!.append(uiColor)
                        //print("setName:\(setName),カラーレッド:\(red)")
                    }
                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
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
            return colorSet.keys.count
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if colorMode == .set {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "base", for: indexPath) as! ColorBaseCell
            //cell.backgroundColor = colors[indexPath.row]
            cell.colorSetView.colorSet = colorSet[colorKeys[indexPath.row]] ?? []
            //print(colorDelegate)
            cell.colorSetView.colorDelegate = colorDelegate
            cell.colorSetView.reloadData()

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customBase", for: indexPath) as! RGBSliderCell
            cell.sliderView.colorDelegate = colorDelegate
            //print(colorDelegate)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        colorPageDelegate.movePage(count: indexPath.row)
    }
}
