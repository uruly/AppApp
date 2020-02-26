//
//  BaseViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//
// コレクションビューを乗せてページングさせるビューコントローラ

import UIKit

//@objc protocol ColorListDelegate {
//    func labelChanged(color:UIColor)
//}

class BaseViewController: UIViewController {

    var appLabel: AppLabelData!
    var collectionView: AppCollectionView!
    //var colorListDelegate:ColorListDelegate!
    var backgroundColor: UIColor? {
        didSet {
            if self.backgroundImage == nil {
                self.collectionView.backgroundColor = self.backgroundColor
            }
        }
    }
    var backgroundImage: UIImage? {
        didSet {
            if backgroundImage == nil {
                self.collectionView.backgroundColor = self.backgroundColor
                //print(self.collectionView.backgroundColor)
            } else {
                self.collectionView.backgroundColor = UIColor(patternImage: self.backgroundImage!)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.frame.width
        let height = self.view.frame.height

        self.view.backgroundColor = UIColor.white

        //とりあえず仮のラベル
        //        let label = UILabel()
        //        label.frame = CGRect(x:0,y:0,width:100,height:50)
        //        label.center = CGPoint(x:width / 2,y:height / 2)
        //        label.text = appLabel.name
        //        self.view.addSubview(label)

        //コレクションビューを配置
        let topMargin = basePageVC.selectionBar.frame.maxY + 4  //+部分がラインになる
        collectionView = AppCollectionView(frame: CGRect(x: 0,
                                                         y: topMargin,
                                                         width: width,
                                                         height: height - topMargin ))
        collectionView.appDelegate = self
        self.view.addSubview(collectionView)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ここでCurrentIDを設定
        //print("BaseViewWillAppear")
        AppLabel.currentID = appLabel.id
        AppLabel.currentOrder = appLabel.order
        AppLabel.currentColor = appLabel.color

        //bottomMenuリロード
        basePageVC.bottomView.baseView.reloadData()
        //bottomMenuのカラー変更
        //        if colorListDelegate != nil {
        //            colorListDelegate.labelChanged(color: appLabel.color)
        //        }
        //delegateを設定
        if self.basePageVC.bottomView.toolbar != nil {
            self.basePageVC.bottomView.toolbar.sliderDelegate = collectionView
            self.collectionView.mode = self.basePageVC.bottomView.toolbar.toolbarMode
            if self.basePageVC.bottomView.toolbar.slider != nil {
                var value = CGFloat(UserDefaults.standard.float(forKey: "IconSize"))
                if value == 0 { value = 50.0 }
                self.basePageVC.bottomView.toolbar.slider.value = Float(value)
                self.collectionView.itemSize = CGSize(width: value, height: value)
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }

        if self.basePageVC.bottomView.editToolbar != nil {
            self.basePageVC.bottomView.editToolbar.editDelegate = self
        }
        collectionView.appDelegate = self
        self.view.backgroundColor = appLabel.color

        GATrackingManager.sendScreenTracking(screenName: "\(appLabel.name!)ラベルページ")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if collectionView.contentSize.height < self.view.frame.size.height {
            print("大きいよ")
            self.basePageVC.bottomView.closeBottomView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func toDetailViewController(appData: ApplicationStruct) {
        let detailVC = DetailViewController()
        detailVC.appData = appData

        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BaseViewController: BasePageViewControllerDelegate {
    var basePageVC: BasePageViewController {
        return parent as! BasePageViewController
    }
}
extension BaseViewController: AppCollectionViewDelegate {
    var baseVC: BaseViewController {
        return self
    }
}

extension BaseViewController: EditToolbarDelegate {

    //これらの操作が終わったら自動的に編集中を終わらせる
    @objc func addLabelBtnTapped() {
        //print("addLabel")
        if collectionView.checkArray.count == 0 {
            return
        }
        let labelListVC = LabelListViewController()
        labelListVC.appList = collectionView.checkArray
        labelListVC.baseVC = self
        basePageVC.present(labelListVC, animated: true, completion: nil)
    }

    @objc func deleteAppBtnTapped() {
        //ポップアップを表示
        let alertController = UIAlertController(title: "Appを削除します。", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Appを削除する", style: .default) { [weak self] _ in
            guard let wself = self else { return }
            wself.collectionView.deleteAppData {
                wself.basePageVC.cancelEdit(sender: wself.basePageVC.navigationItem.rightBarButtonItem!)
            }
        })
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel))

        present(alertController, animated: true, completion: nil)
    }

    @objc func shareAppBtnTapped() {
        //print("share")
    }

}