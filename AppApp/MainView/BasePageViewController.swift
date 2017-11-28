//
//  BasePageViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//
// メイン画面のページビューコントローラ

import UIKit

protocol BasePageViewControllerDelegate {
    var basePageVC:BasePageViewController { get }
}


class BasePageViewController: UIPageViewController {
    
    var isInfinity = false //無限スクロールにするかどうか
    var appLabel:AppLabel!
    var selectionBar:SelectionBar!
    static var isUnwind = false
    var lastContentOffsetX:CGFloat = 0
    var currentPageIndex:Int = 0
    var nextPageIndex:Int = 0
    var isSelectionScroll = true
    var iconSizeChanger:IconSizeChanger!
    var editToolbar:EditToolbar!
    var isGoDetail = false
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle:.scroll,navigationOrientation:.horizontal,options:options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = UIColor.backgroundGray()
        appLabel = AppLabel()
        
        //ナビゲーションバーをカスタマイズ
        self.title = "AppApp"
        //let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editTapped(sender:)))
        let editBtn = UIBarButtonItem(title: "選択", style: .plain, target: self, action: #selector(self.editTapped(sender:)))
        self.navigationItem.rightBarButtonItem = editBtn
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 56
        print(navigationBarHeight)
        //セレクションバーを配置
        selectionBar = SelectionBar(frame:CGRect(x:0,y:navigationBarHeight,width:width,height:65),pageVC:self)
        self.view.addSubview(selectionBar)
        
        //toolbarを配置
        let toolbarHeight = self.navigationController?.toolbar.frame.height ?? 44
        iconSizeChanger = IconSizeChanger(frame:CGRect(x:0,
                                                       y:height - toolbarHeight,
                                                       width:width,
                                                       height:toolbarHeight))
        self.view.addSubview(iconSizeChanger)
        
        //同じ位置にEditToolbarを配置
        editToolbar = EditToolbar(frame: iconSizeChanger.frame)
        editToolbar.isHidden = true
        self.view.addSubview(editToolbar)
        
        if appLabel.array.count > 0 {
            self.setViewControllers([getBase(appLabel: appLabel.array[0])], direction: .forward, animated: true, completion: nil)
        }
        self.dataSource = self
        self.delegate = self as? UIPageViewControllerDelegate
        
        let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if BasePageViewController.isUnwind{
            print("truedayo")
            appLabel.reloadLabelData()
            selectionBar.reloadData()
            selectionBar.collectionViewLayout.invalidateLayout()
            if !appLabel.array.contains(where: {$0.id == AppLabel.currentID}){
                self.setViewControllers([getBase(appLabel: appLabel.array[0])], direction: .forward, animated: false, completion: nil)
            }else {
                self.setViewControllers([getBase(appLabel: appLabel.array[AppLabel.currentOrder!])], direction: .forward, animated: false, completion: nil)
            }
            if self.navigationItem.rightBarButtonItem != nil {
                cancelEdit(sender:self.navigationItem.rightBarButtonItem!)
            }
        }
    }

    func reloadPage(order:Int){
        self.setViewControllers([getBase(appLabel: appLabel.array[order])], direction: .forward, animated: false, completion: nil)
    }
    
    func getBase(appLabel:AppLabelData) -> BaseViewController {
        let baseView = BaseViewController()
        baseView.appLabel = appLabel
        return baseView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAppLabel(){
        let createLabelVC = CreateAppLabelViewController()
        let naviVC = UINavigationController(rootViewController: createLabelVC)
        self.present(naviVC, animated: true, completion: nil)
    }
    
    func editAppLabel(label:AppLabelData){
        if isGoDetail {
            return
        }
        isGoDetail = true
        let editLabelVC = EditAppLabelViewController()
        //今の値を入れておく
        editLabelVC.currentName = label.name
        editLabelVC.order = label.order
        editLabelVC.color = label.color
        editLabelVC.id = label.id
        editLabelVC.explain = label.explain
        
        let naviVC = UINavigationController(rootViewController: editLabelVC)
        self.present(naviVC, animated: true, completion: {
            self.isGoDetail = false
        })
    }
    
    //編集中にする
    @objc func editTapped(sender:UIBarButtonItem){
        let isWhileEditing = AppCollectionView.isWhileEditing
        let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
        if isWhileEditing {
            //編集中を解除する
            cancelEdit(sender: sender)
        }else{
            //編集中にする
            AppCollectionView.isWhileEditing = true
            sender.title = "キャンセル"
            //スクロールできないようにする
            let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
            scrollView?.isScrollEnabled = false
            if let baseVC:BaseViewController = self.viewControllers?[0] as? BaseViewController{
                baseVC.collectionView.checkArray = []
                baseVC.collectionView.reloadData()
            }
            
            //edittoolbarを表示
            editToolbar.isHidden = false
        }
        
    }
    func cancelEdit(sender:UIBarButtonItem){
        //編集中を解除する
        AppCollectionView.isWhileEditing = false
        let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.isScrollEnabled = true
        sender.title = "選択"
        if let baseVC:BaseViewController = self.viewControllers?[0] as? BaseViewController{
            baseVC.collectionView.checkArray = []
            baseVC.collectionView.reloadData()
        }
        editToolbar.isHidden = true
    }
}
extension BasePageViewController: UIPageViewControllerDataSource {
    //ページが戻る
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //現在の位置で場合分け
        if viewController.isKind(of: BaseViewController.self){
            let currentView = viewController as! BaseViewController
            let prevValue = AppLabel.currentOrder! - 1
            if(prevValue < 0){
                return self.isInfinity ? getBase(appLabel:appLabel.array.last!) : nil
            }
            return getBase(appLabel: appLabel.array[prevValue])
        }else{
            return nil
        }
    }
    
    //ページが進む
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //現在の位置で場合分け
        if viewController.isKind(of: BaseViewController.self){
            let currentView = viewController as! BaseViewController
            let nextValue = AppLabel.currentOrder! + 1
            if(nextValue > appLabel.array.count - 1){
                return self.isInfinity ? getBase(appLabel:appLabel.array.first!) : nil
            }
            return getBase(appLabel:appLabel.array[nextValue])
        }else{
            return nil
        }
    }
    
}
extension BasePageViewController:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransiton")
        if let curVC = pageViewController.viewControllers?.first,curVC.isKind(of:BaseViewController.self){
            let currentVC = curVC as! BaseViewController
            print(currentVC.appLabel.name)
            self.currentPageIndex = currentVC.appLabel.order
        }
        if let neVC = pendingViewControllers.first,neVC.isKind(of: BaseViewController.self){
            let nextVC = neVC as! BaseViewController
            print(nextVC.appLabel.name)
            self.nextPageIndex = nextVC.appLabel.order
            if fabs(Double(self.currentPageIndex - self.nextPageIndex)) > 1{
                selectionBar.diffX = 0
            }else{
                selectionBar.setDiffX(nextIndex: self.nextPageIndex)
            }
        }

    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let prevVC = previousViewControllers.first,prevVC.isKind(of: BaseViewController.self){
            let previousVC = prevVC as! BaseViewController
            print(previousVC.appLabel.name)
            if let curVC = pageViewController.viewControllers?.first,curVC.isKind(of:BaseViewController.self){
                let currentVC = curVC as! BaseViewController
                print(currentVC.appLabel.name)
                self.currentPageIndex = currentVC.appLabel.order
                selectionBar.scrollAdjust(index:self.currentPageIndex)
            }
        }
        print("っここ")
        print("previousView\(previousViewControllers)")
    }
}

extension BasePageViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Drag開始")
        isSelectionScroll = true
        lastContentOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("スクロール中\(scrollView.contentOffset.x)")
        //ここでカテゴリバーを移動させる
        let diffX = scrollView.contentOffset.x - lastContentOffsetX
        if fabs(diffX) < 200 && isSelectionScroll{
            //selectionBar.scrollToHorizontallyCenter(index:self.nextPageIndex ,x:diffX)
        }
        lastContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("didendDrag")
        //isSelectionScroll = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //指が離れたとき、近い方にカテゴリを移動
        
    }
}
