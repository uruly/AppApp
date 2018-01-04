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
    let handleHeight:CGFloat = 40.0
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
    var barLayer:CAShapeLayer!

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
        //self.backgroundColor = UIColor.white
        
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
        //ハンドル
        let handleWidth:CGFloat = 50.0
        let handle = UIView(frame: CGRect(x:2,y:10,width:handleWidth,height:handleHeight))
        handle.backgroundColor = UIColor.white
        //角丸をつける
        handle.layer.cornerRadius = 10.0
        
        //影をつける
        handle.layer.masksToBounds = false
        handle.layer.shadowColor = UIColor.darkGray.cgColor
        handle.layer.shadowOffset = CGSize(width:-1,height:1)
        handle.layer.shadowRadius = 2
        handle.layer.shadowOpacity = 0.2
        
        //shapeLayer
        barLayer = CAShapeLayer()
        barLayer.fillColor = UIColor.clear.cgColor
        barLayer.strokeColor = UIColor.gray.cgColor
        barLayer.lineWidth = 4.0
        barLayer.lineCap = kCALineCapRound
        barLayer.lineJoin = kCALineJoinRound
        let margin:CGFloat = 16
        let startPos = CGPoint(x:margin,y: handleHeight / 2)
        let middlePos = CGPoint(x:handleWidth / 2,y:handleHeight / 2 + 5)
        let endPos = CGPoint(x:handleWidth - margin,y:handleHeight / 2)
        //let controlPos = CGPoint(x:handleWidth / 2,y:0)
        let line = UIBezierPath()
        line.move(to: startPos)
        line.addLine(to:middlePos)
        //line.addQuadCurve(to: endPos, controlPoint: controlPos)
        line.addLine(to:endPos)
        //line.close()
        barLayer.path = line.cgPath
        handle.layer.addSublayer(barLayer)
        
        self.addSubview(handle)
        
        //ツールバー
        toolbar = IconSizeChanger(frame:CGRect(x:0,y:handleHeight,width:self.width,height:toolbarHeight))
        self.addSubview(toolbar)
        editToolbar = EditToolbar(frame: toolbar.frame)
        editToolbar.isHidden = true
        self.addSubview(editToolbar)
    }
    
    func setupPageView() {
        baseView = BottomMenuBaseView(frame: CGRect(x:0,y:handleHeight + toolbarHeight,width:self.width,height:height - toolbarHeight - handleHeight))
        baseView.pageDelegate = self
        self.addSubview(baseView)
        
        setupPageControl()
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
        print("touch")
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
            print(isCompletion)
        })
    }
}

extension BottomView: BottomMenuPageControlDelegate{
    func movePage(count: Int) {
        self.pageControl.currentPage = count
    }
}
