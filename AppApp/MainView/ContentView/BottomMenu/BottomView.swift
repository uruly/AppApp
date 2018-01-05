//
//  BottomView.swift
//  BottomMenu
//
//  Created by 久保　玲於奈 on 2018/01/04.
//  Copyright © 2018年 久保　玲於奈. All rights reserved.
//

import UIKit

@objc protocol BottomMenuDelegate {
    var parentView:UIView { get }
}

class BottomView: UIView {
    
    let width:CGFloat
    let height:CGFloat
    let toolbarHeight:CGFloat = 56.0
    let handleHeight:CGFloat = 15.0
    let maxY:CGFloat    //閉じられた状態
    let middleY:CGFloat
    let minY:CGFloat    //menuが開かれた状態
    var delegate:BottomMenuDelegate!
    var lastDiffY:CGFloat = 0 //勢いを見る
    let maxSpeed:CGFloat = 12.0
    var pageControl:UIPageControl!
    var baseView:BottomMenuBaseView!
    var toolbar:IconSizeChanger!
    var editToolbar:EditToolbar!
    
    required init?(coder aDecoder: NSCoder) {
        self.width = 0
        self.height = 0
        self.maxY = 0
        self.middleY = 0
        self.minY = 0
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        self.width = frame.width
        self.height = frame.height
        self.maxY = frame.maxY - toolbarHeight - handleHeight
        self.minY = frame.origin.y
        self.middleY = minY + ( frame.height / 2 )
        super.init(frame:frame)
        self.backgroundColor = UIColor.white
        
        //常に見えている部分(toolbar部分)
        setupToolbar()
        
        //下からにょっと出てくる部分
        setupPageView()
        
        self.layer.cornerRadius = 10.0
        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0,height:-2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
    }
    
    func setupToolbar() {
        let handleWidth:CGFloat = 40.0
        toolbar = IconSizeChanger(frame:CGRect(x:0,y:handleHeight,width:self.width,height:toolbarHeight))
        self.addSubview(toolbar)
        editToolbar = EditToolbar(frame: toolbar.frame)
        editToolbar.isHidden = true
        self.addSubview(editToolbar)
        
        //ハンドル
        let handle = CALayer()
        handle.frame = CGRect(x:(self.width / 2) - ( handleWidth / 2 ),y:handleHeight / 2 - 2.5,width:handleWidth,height:5)
        
        let handleBar = CAShapeLayer()
        //handleBar.frame = CGRect(x:width - 40,y:1,width:80,height:handleHeight - 2)
        handleBar.fillColor = UIColor.lightGray.cgColor
        handleBar.strokeColor = UIColor.lightGray.cgColor
        handleBar.opacity = 0.7
        handleBar.path = UIBezierPath(roundedRect: CGRect(x:0,y:0,width:handleWidth,height:5),  cornerRadius:( handleHeight - 2 ) / 2).cgPath
        if let blurFilter = CIFilter(name: "CIGaussianBlur",
                                     withInputParameters: [kCIInputRadiusKey: 2]) {
            handleBar.backgroundFilters = [blurFilter]
        }
        
        handle.addSublayer(handleBar)
        self.layer.addSublayer(handle)
        
    }
    
    func setupPageView() {
        baseView = BottomMenuBaseView(frame: CGRect(x:0,
                                                    y:toolbarHeight + handleHeight,
                                                    width:self.width,
                                                    height:height - toolbarHeight - handleHeight))
        baseView.pageDelegate = self
        self.addSubview(baseView)
        
        setupPageControl()
        
        //bottomline
        let bottomLine = UIView(frame:CGRect(x:0,y:handleHeight + toolbarHeight,
                                             width:self.width,height:0.8))
        bottomLine.backgroundColor = UIColor.backgroundGray()
        self.addSubview(bottomLine)
    }
    
    func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x:0,y:self.frame.height - 40,width:self.frame.width,height:40))
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.addTarget(self, action: #selector(self.pageControlTapped(sender:)), for: .touchUpInside)
        self.addSubview(pageControl)
    }
    
    @objc func pageControlTapped(sender:UIPageControl){
        //print(sender.currentPage)
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        baseView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    //タッチイベントを取得
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
        //print("touch")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesMoved(touches, with: event)
        guard let touch = touches.first else{
            return
        }
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        //print("location\(location)")
        //print("previousLocation\(previousLocation)")
        var frame = self.frame
        let diffY = location.y - previousLocation.y
        frame.origin.y += diffY
        
        if frame.origin.y <= minY {
            return
        }
        self.frame = frame
        
        //勢い
        lastDiffY = diffY
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //勢いをみてどっちに行くか決める
        updateFrame()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //近い方にスクロールする
        updateFrame()
    }
    
    func updateFrame(){
        //近い方にスクロールする
        var frame = self.frame
        
        if lastDiffY > maxSpeed {
            //スピードが早いとき　閉じる
            frame.origin.y = maxY
        }else if lastDiffY < -maxSpeed {
            //スピードが早いとき 開く
            frame.origin.y = minY
        }else {
            //スピードが遅いとき
            if frame.origin.y > middleY {
                //maxYにする 閉じる
                frame.origin.y = maxY
            }else {
                //minYにする 開く
                frame.origin.y = minY
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.frame = frame
        }, completion: { (isCompletion) in
            //print(isCompletion)
        })
    }
}

extension BottomView: BottomMenuPageControlDelegate{
    func movePage(count: Int) {
        self.pageControl.currentPage = count
    }
}
