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
        AppLabel.currentID = appLabel.id
        AppLabel.currentOrder = appLabel.order
        //delegateを設定
        if self.basePageVC.iconSizeChanger != nil {
            self.basePageVC.iconSizeChanger.sliderDelegate = collectionView
            var value = CGFloat(UserDefaults.standard.float(forKey:"IconSize"))
            if value == 0 { value = 50.0 }
            self.basePageVC.iconSizeChanger.slider.value = Float(value)
            self.collectionView.itemSize = CGSize(width:value,height:value)
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        if self.basePageVC.editToolbar != nil {
            self.basePageVC.editToolbar.editDelegate = self
        }
        collectionView.appDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toDetailViewController(appData:AppData){
        let detailVC = DetailViewController()
        detailVC.appData = appData
        
        self.navigationController?.pushViewController(detailVC, animated: true)
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

extension BaseViewController: EditToolbarDelegate {
    
    //これらの操作が終わったら自動的に編集中を終わらせる
    @objc func addLabelBtnTapped() {
        print("addLabel")
    }
    
    @objc func deleteAppBtnTapped() {
        //ポップアップを表示
        let alertController = UIAlertController(title: "画像を削除します。", message: "", preferredStyle: .actionSheet)
        let otherAction = UIAlertAction(title: "画像を削除する", style: .default) {
            action in NSLog("はいボタンが押されました")
            self.collectionView.deleteAppData()
            self.basePageVC.cancelEdit(sender: self.basePageVC.navigationItem.rightBarButtonItem!)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) {
            action in NSLog("いいえボタンが押されました")
        }
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func shareAppBtnTapped() {
        print("share")
    }
    
    
}

