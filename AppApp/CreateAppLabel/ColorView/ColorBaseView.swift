//
//  ColorBaseView.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit


class ColorBaseView: UIView {

    var pageControl:UIPageControl!
    var pageView:ColorPageView!
    var toolbar:UIToolbar!
    
    let toolbarHeight:CGFloat = 40.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupToolbar()
        setupPageView()
        setupPageControl()
    }
    
    func setupToolbar(){
        let colorSetBtn = UIButton()
        colorSetBtn.frame = CGRect(x:0,y:0,width:130,height:toolbarHeight)
        colorSetBtn.setTitle("カラーセット", for: .normal)
        colorSetBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        colorSetBtn.backgroundColor = UIColor.blue
        colorSetBtn.addTarget(self, action: #selector(self.changeMode), for: .touchUpInside)
        self.addSubview(colorSetBtn)
        
        let customBtn = UIButton()
        customBtn.frame = CGRect(x:colorSetBtn.frame.maxX,y:0,width:80,height:toolbarHeight)
        customBtn.setTitle("カスタム", for: .normal)
        customBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        customBtn.backgroundColor = UIColor.cyan
        customBtn.addTarget(self, action: #selector(self.changeMode), for: .touchUpInside)
        self.addSubview(customBtn)
        
        let doneBtn = UIButton()
        doneBtn.frame = CGRect(x:self.frame.width - 50,y:0,width:50,height:toolbarHeight)
        doneBtn.setTitle("完了", for: .normal)
        doneBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        doneBtn.backgroundColor = UIColor.gray
        self.addSubview(doneBtn)
        
        colorSetBtn.layer.mask = roundedCorner(bounds: colorSetBtn.bounds)
        
        
        customBtn.layer.mask = roundedCorner(bounds: customBtn.bounds)
        doneBtn.layer.mask = roundedCorner(bounds: doneBtn.bounds)
    }
    
    func roundedCorner(bounds:CGRect) -> CAShapeLayer{
        //角丸をつける
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width:10,height:10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        return maskLayer
    }
    
    func setupPageView(){
        pageView = ColorPageView(frame:CGRect(x:0,y:toolbarHeight,width:self.frame.width,height:self.frame.height - toolbarHeight))
        pageView.colorDelegate = self
        self.addSubview(pageView)
    }
    
    func setupPageControl(){
        pageControl = UIPageControl(frame: CGRect(x:0,y:self.frame.height - 40,width:self.frame.width,height:40))
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.pageView.colors.count
        //pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.addTarget(self, action: #selector(self.pageControlTapped(sender:)), for: .touchUpInside)
        self.addSubview(pageControl)
    }
    
    @objc func pageControlTapped(sender:UIPageControl){
        print(sender.currentPage)
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        pageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func doneBtnTapped(){
        print("done")
    }
    
    @objc func changeMode(){
        let currentMode = pageView.colorMode
        if currentMode == .set {
            pageView.colorMode = .custom
            pageControl.isHidden = true
        }else {
            pageView.colorMode = .set
            pageControl.isHidden = false
        }
    }

}

extension ColorBaseView: ColorPageControlDelegate{
    func movePage(count: Int) {
        self.pageControl.currentPage = count
    }
}

