//
//  ColorPicker.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2017/11/26.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol ColorDelegate{
    @objc optional func pickedColor(color:UIColor,endState:Bool)
}


class ColorPicker: UIView {
    var delegate: ColorDelegate!
    // 細かさの設定
    //var xCount = 15
    var xCount = 10
    var yCount = 20
    
    var blockSize: CGSize! = nil
    var size: CGSize! = nil
    
    func setup() {
        self.size = self.bounds.size
    }
    
    func colorFromPos(posH: Int, posS: Int) -> UIColor {
        // 白〜黒のやつ
        if posH == 0 {
            return UIColor(hue: 0, saturation: 0, brightness: 1.0-CGFloat(posS)/CGFloat(xCount-1), alpha: 1.0)
        } else {
            return UIColor(hue: CGFloat(posH-1)/CGFloat(yCount-1), saturation: CGFloat(posS+1)/CGFloat(xCount), brightness: 1.0, alpha: 1.0)
        }
    }
    
    func colorFromPoint(point: CGPoint) -> UIColor {
        let posX = Int(point.x * CGFloat(xCount) / size.width)
        let posY = Int(point.y * CGFloat(yCount) / size.height)
        return colorFromPos(posH: posY, posS: posX)
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        print(size)
        let blockSize = CGSize(width:size.width / CGFloat(xCount), height:size.height / CGFloat(yCount))
        
        for i in 0...yCount {
            for j in 0...xCount {
                let color = colorFromPos(posH: i, posS: j)
                color.setFill()
                let blockRect = CGRect(
                    origin: CGPoint(x:blockSize.width*CGFloat(j), y:blockSize.height*CGFloat(i)),
                    size: blockSize
                )
                context!.fill(blockRect)
            }
        }
    }
    //カラーのラベルのところだけ色を変えるとか
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch =  touches.first
        updateColor(touch: touch!)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch =  touches.first
        updateColor(touch: touch!)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch =  touches.first
        updateColorEnd(touch: touch!)
    }
    
    func updateColorEnd(touch: UITouch){
        let selectedColor = colorFromPoint(point: touch.location(in:self))
        self.delegate.pickedColor!(color: selectedColor,endState:true)
        self.setNeedsDisplay()
    }
    func updateColor(touch: UITouch){
        let selectedColor = colorFromPoint(point:touch.location(in:self))
        self.delegate.pickedColor!(color: selectedColor,endState:false)
        self.setNeedsDisplay()
    }
    
}

class FakeView: UIView {
    var delegate:CreateLabelViewController!
    var pickerTag:Int!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("多ｔｔぷ")
        self.delegate.dismissPickerView(tag:pickerTag)
        self.removeFromSuperview()
    }
}

