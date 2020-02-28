//
//  BalloonView.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class BalloonView: UIView {

    var label: UILabel!
    var isDown: Bool! {
        didSet {
            setup()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = color
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if isDown {
            drawBalloonDown()
        } else {
            drawBalloonUp()
        }
    }

    func setup() {
        let margin: CGFloat = isDown ? 0 : 20
        label = UILabel(frame: CGRect(x: 0, y: margin, width: self.frame.width, height: self.frame.height - 20))
        label.text = "タップでお気に入りに登録"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16 + VersionManager.excessiPad)
        label.numberOfLines = 0
        self.addSubview(label)
    }

    func drawBalloonDown() {
        let tag = CAShapeLayer()
        let width = self.frame.width
        let height = self.frame.height
        tag.strokeColor = UIColor.clear.cgColor
        tag.fillColor = UIColor.white.cgColor
        tag.lineWidth = 1.0

        let rect = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height - 20), cornerRadius: 20)
        tag.path = rect.cgPath

        let line = UIBezierPath()

        let startPos = CGPoint(x: width - 30, y: height - 30)
        let middlePos = CGPoint(x: width - 40, y: height + 10)
        let endPos = CGPoint(x: width - 50, y: height - 30)

        let triangleLayer = CAShapeLayer()
        line.move(to: startPos)
        line.addQuadCurve(to: endPos, controlPoint: middlePos)
        line.close()
        triangleLayer.path = line.cgPath
        tag.addSublayer(triangleLayer)
        //        //影をつける
        //        let shadow = CALayer()
        //        shadow.frame = self.frame
        //        shadow.shadowColor = UIColor.darkGray.cgColor
        //        shadow.shadowOffset = CGSize(width:1,height:4)
        //        shadow.shadowRadius = 5
        //        shadow.shadowOpacity = 0.8
        //        tag.addSublayer(shadow)

        self.layer.mask = tag

    }

    func drawBalloonUp() {
        let tag = CAShapeLayer()
        let width = self.frame.width
        let height = self.frame.height
        tag.strokeColor = UIColor.clear.cgColor
        tag.fillColor = R.color.flowerLeavesColor()!.cgColor
        tag.lineWidth = 1.0

        let rect = UIBezierPath(roundedRect: CGRect(x: 0, y: 20, width: width, height: height - 20), cornerRadius: 20)
        tag.path = rect.cgPath

        let line = UIBezierPath()

        let startPos = CGPoint(x: width - 30, y: 30)
        let middlePos = CGPoint(x: width - 40, y: -10)
        let endPos = CGPoint(x: width - 50, y: 30)

        let triangleLayer = CAShapeLayer()
        line.move(to: startPos)
        line.addQuadCurve(to: endPos, controlPoint: middlePos)
        line.close()
        triangleLayer.path = line.cgPath
        tag.addSublayer(triangleLayer)
        //        //影をつける
        //        let shadow = CALayer()
        //        shadow.frame = self.frame
        //        shadow.shadowColor = UIColor.darkGray.cgColor
        //        shadow.shadowOffset = CGSize(width:1,height:4)
        //        shadow.shadowRadius = 5
        //        shadow.shadowOpacity = 0.8
        //        tag.addSublayer(shadow)

        self.layer.mask = tag

    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
