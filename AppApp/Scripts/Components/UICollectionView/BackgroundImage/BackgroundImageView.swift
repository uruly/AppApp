//
//  BackgroundImageView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class BackgroundImageView: UICollectionView {

    var imageList: [(UIImage, String)] = []
    var currentIndexPath: IndexPath?
    var currentImage: UIImage?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.sectionInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 0)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.init(frame: frame, collectionViewLayout: layout)

        self.register(UINib(nibName: "BackgroundImageCell", bundle: nil), forCellWithReuseIdentifier: "backImageSet")
        self.register(BackgroundPlusCell.self, forCellWithReuseIdentifier: "plus")
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white

    }

    func changeBackgroundImage() {
        //BackgroundColorListView.isDefaultColor = false
        if let basePageVC: BasePageViewController = findViewController() {
            //print("basepageVCあるよ")
            if let baseVC: BaseViewController = basePageVC.viewControllers?.first as? BaseViewController {
                AppLabel.currentBackgroundImage = currentImage
                baseVC.backgroundImage = currentImage
            }
        }
    }

    override func reloadData() {
        readImage()
        if let backgroundImage = UserDefaults.standard.data(forKey: "backgroundImage") {
            let index = imageList.findIndex(includeElement: { (image) -> Bool in
                let imgListData = image.0.pngData()
                return imgListData == backgroundImage
            })
            if index.count > 0 {
                currentIndexPath = IndexPath(row: index[0], section: 0)
            }
        }
        super.reloadData()
    }

    func readImage() {
        self.imageList = []
        let path = Bundle.main.path(forResource: "backgroundImage", ofType: "json")
        do {
            let jsonString = try String(contentsOfFile: path!)
            let jsonData: Data =  jsonString.data(using: String.Encoding.utf8)!
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
                let top = json as! NSArray
                for object in top {
                    let set = object as! NSDictionary
                    guard let name = set["Name"] as? String else {
                        continue
                    }
                    guard let type = set["Type"] as? String else {
                        continue
                    }
                    if let image = UIImage(named: name + "_thumb." + type) {
                        //image.description = name
                        imageList.append((image, (name + "." + type)))
                    }

                }
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}

extension BackgroundImageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //print(currentIndexPath)
            //print(indexPath)
            if currentIndexPath == indexPath {
                if let previousCell: BackgroundImageCell = collectionView.cellForItem(at: currentIndexPath!) as? BackgroundImageCell {
                    previousCell.checkImageView.isHidden = true
                }
                currentImage = nil
                currentIndexPath = nil
            } else {
                if currentIndexPath != nil {
                    if let previousCell: BackgroundImageCell = collectionView.cellForItem(at: currentIndexPath!) as? BackgroundImageCell {
                        //print("けすよ")
                        previousCell.checkImageView.isHidden = true
                    }
                }
                if let cell: BackgroundImageCell = collectionView.cellForItem(at: indexPath) as? BackgroundImageCell {
                    //print("みせるよ")
                    //print("imageList[index]\(imageList[indexPath.row])")
                    cell.checkImageView.isHidden = false
                    currentImage = UIImage(named: imageList[indexPath.row].1)
                    currentIndexPath = indexPath
                }
            }

            changeBackgroundImage()
        } else {
            //カラーピッカーを表示
        }
    }
}

extension BackgroundImageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return imageList.count > 5 ? 5 : imageList.count
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: BackgroundImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "backImageSet", for: indexPath) as! BackgroundImageCell
            let color = UIColor(patternImage: imageList[indexPath.row].0)
            //let colorName = color.value(forKey: "image") as? String ?? ""
            //color.setValue(colorName, forKey: "image")
            cell.contentView.backgroundColor = color
            if currentIndexPath == indexPath {
                cell.checkImageView.isHidden = false
            } else {
                cell.checkImageView.isHidden = true
            }
            return cell
        } else {
            let cell: BackgroundPlusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "plus", for: indexPath) as! BackgroundPlusCell
            return cell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return 2
        return 1
    }

}
