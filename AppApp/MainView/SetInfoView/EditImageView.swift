//
//  EditImageView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

//ドラッグ & ズームイン・ズームアウト　ができる
import UIKit

class EditImageView: UIImageView {

    //var lastPoint:CGPoint = CGPoint.zero
    var selectLayer:CALayer?
    var effectiveScale:CGFloat = 1
    var beginGestureScale:CGFloat = 1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFill
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 40.0
        self.backgroundColor = UIColor.gray
        //影をつける
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.darkGray.cgColor
        
        //zoom
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
    }
    
    @objc func pinch(sender:UIPinchGestureRecognizer){
        print(sender.scale)
        effectiveScale = beginGestureScale * sender.scale
        //選択されてるやつだけ
        if (selectLayer != nil){
            selectLayer!.setAffineTransform(CGAffineTransform(scaleX: effectiveScale,y:effectiveScale))
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBega")
        if let touch = touches.first {
            let layer = hitLayer(touch: touch)
            if layer.name == "image" {
                selectLayer = layer
            }

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("moved")
        if selectLayer == nil {
            return
        }
        if let touch = touches.first {
            let point = touch.location(in: self)
            let previousPoint = touch.previousLocation(in: self)
            
            let diffX = point.x - previousPoint.x
            let diffY = point.y - previousPoint.y

            print(selectLayer?.frame.maxX)
            //レイヤーを移動させる
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let nextPointX = selectLayer!.position.x + diffX
            let nextPointY = selectLayer!.position.y + diffY
            
            selectLayer!.position.x += diffX
            selectLayer!.position.y += diffY
//            print("nextPointX\(nextPointX)")
//            print("nextPointY\(nextPointY)")
//            if nextPointX > selectLayer!.frame.width / 2 && nextPointX < self.frame.maxX - ( selectLayer!.frame.width / 2 ){
//                selectLayer!.position.x += diffX
//            }
//
//            if nextPointY > selectLayer!.frame.height / 2 && nextPointY < self.frame.maxY - ( selectLayer!.frame.height / 2) {
//                selectLayer!.position.y += diffY
//            }
////            if selectLayer!.frame.minX <= 0{
//                //selectLayer!.position.x = selectLayer!.frame.width / 2
//            }else if selectLayer!.frame.maxX < self.frame.maxX{
//                //selectLayer!.position.x = self.frame.maxX - (selectLayer!.frame.width / 2)
//            }else {
//                selectLayer!.position.x += diffX
//            }
//
//            if selectLayer!.frame.minY <= 0 {
//                //selectLayer!.position.y = selectLayer!.frame.height / 2
//            }else if selectLayer!.frame.maxY < self.frame.maxY {
//                //selectLayer!.position.y = self.frame.maxY - (selectLayer!.frame.height / 2)
//            }else {
//                selectLayer!.position.y += diffY
//            }
            CATransaction.commit()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("end")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancel")
    }
    
    func hitLayer(touch:UITouch) -> CALayer{
        var touchPoint:CGPoint = touch.location(in:self)
        touchPoint = self.layer.convert(touchPoint, to: self.layer.superlayer)
        return self.layer.hitTest(touchPoint)!
    }
}

extension EditImageView:UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer.isKind(of:UIPinchGestureRecognizer.self)){
            beginGestureScale = effectiveScale
        }
        return true
    }
}
