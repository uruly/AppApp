//
//  TutorialViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    var pageView:TutorialPageView!
    var pageControl:UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.frame.width
        let height = self.view.frame.height
        let navigationHeight:CGFloat = 80.0
        let margin:CGFloat = 15.0
        pageView = TutorialPageView(frame: CGRect(x:0,y:navigationHeight + margin,width:width,height:height - navigationHeight - margin))
        pageView.pageDelegate = self
        self.view.addSubview(pageView)
        
        setupPageControl()
    }
    
    func setupPageControl(){
        pageControl = UIPageControl(frame: CGRect(x:0,y:self.view.frame.height - 40,width:self.view.frame.width,height:40))
        pageControl.currentPage = 0
        pageControl.numberOfPages = 5
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.addTarget(self, action: #selector(self.pageControlTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(pageControl)
    }
    

    @objc func pageControlTapped(sender:UIPageControl){
        print(sender.currentPage)
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        pageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension TutorialViewController: TutorialPageControlDelegate{
    func movePage(count: Int) {
        self.pageControl.currentPage = count
    }

}

