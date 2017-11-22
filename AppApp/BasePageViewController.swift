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
    
    var isInfinity = true //無限スクロールにするかどうか
    var appLabel:AppLabel!
    var selectionBar:SelectionBar!
    static var isUnwind = false
    var lastContentOffsetX:CGFloat!
    var currentPageIndex:Int = 0
    var nextPageIndex:Int = 0
    var isSelectionScroll = true
    var iconSizeChanger:IconSizeChanger!
    
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
        print(appLabel.array)
        
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
            appLabel.reloadLabelData()
            selectionBar.reloadData()
        }
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
        self.present(createLabelVC, animated: true, completion: nil)
    }
}
extension BasePageViewController: UIPageViewControllerDataSource {
    //ページが戻る
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //現在の位置で場合分け
        if viewController.isKind(of: BaseViewController.self){
            let currentView = viewController as! BaseViewController
            let prevValue = currentView.appLabel.order - 1
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
            let nextValue = currentView.appLabel.order + 1
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
