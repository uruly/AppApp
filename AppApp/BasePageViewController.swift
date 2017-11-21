//
//  BasePageViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//
// メイン画面のページビューコントローラ

import UIKit

class BasePageViewController: UIPageViewController {
    
    var isInfinity = false //無限スクロールにするかどうか
    var appLabel:AppLabel!
    var selectionBar:SelectionBar!
    static var isUnwind = false
    
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
        self.view.backgroundColor = UIColor.purple
        appLabel = AppLabel()
        print(appLabel.array)
        if appLabel.array.count > 0 {
            self.setViewControllers([getBase(appLabel: appLabel.array[0])], direction: .forward, animated: true, completion: nil)
        }
        self.dataSource = self
        self.delegate = self as? UIPageViewControllerDelegate
        
        let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.delegate = self
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 56
        print(navigationBarHeight)
        //セレクションバーを配置
        selectionBar = SelectionBar(frame:CGRect(x:0,y:navigationBarHeight,width:width,height:65),pageVC:self)
        self.view.addSubview(selectionBar)
        
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

extension BasePageViewController: UIScrollViewDelegate {
    
}
