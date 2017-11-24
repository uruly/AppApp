//
//  BaseViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//
// コレクションビューを乗せてページングさせるビューコントローラ

import UIKit

class BaseViewController: UIViewController {

    var appLabel:AppLabelData!
    var collectionView:AppCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        self.view.backgroundColor = appLabel.color

        //とりあえず仮のラベル
        let label = UILabel()
        label.frame = CGRect(x:0,y:0,width:100,height:50)
        label.center = CGPoint(x:width / 2,y:height / 2)
        label.text = appLabel.name
        self.view.addSubview(label)
        
        //コレクションビューを配置
        let topMargin = basePageVC.selectionBar.frame.maxY + 7  //+部分がラインになる
        collectionView = AppCollectionView(frame: CGRect(x:0,
                                                             y:topMargin,
                                                             width:width,
                                                             height:height - topMargin ))
        collectionView.appDelegate = self
        self.view.addSubview(collectionView)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ここでCurrentIDを設定
        AppLabel.currentID = appLabel.order
        
        //delegateを設定
        if self.basePageVC.iconSizeChanger != nil {
            self.basePageVC.iconSizeChanger.sliderDelegate = collectionView
        }
        collectionView.appDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BaseViewController: BasePageViewControllerDelegate {
    var basePageVC:BasePageViewController {
        return parent as! BasePageViewController
    }
}
extension BaseViewController: AppCollectionViewDelegate{
    var baseVC:BaseViewController {
        return self
    }
}

