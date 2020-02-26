//
//  IconSizeChanger.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol IconSizeChangerDelegate {
    @objc func sliderValueChanged(sender: UISlider)
    var collectionView: AppCollectionView { get }
}

enum ToolbarMode {
    case collect
    case list
}

class IconSizeChanger: UIToolbar {

    //AppSizeを変えるスライダー
    var slider: UISlider!
    var sliderDelegate: IconSizeChangerDelegate! {
        didSet {
            if slider != nil {
                slider.addTarget(sliderDelegate, action: #selector(sliderDelegate.sliderValueChanged(sender:)), for: .valueChanged)
            }
        }
    }
    var toolbarMode: ToolbarMode! {
        didSet {
            if sliderDelegate != nil {
                sliderDelegate.collectionView.mode = toolbarMode
            }
            let userDefaults = UserDefaults.standard
            let isList = toolbarMode == .list
            userDefaults.set(isList, forKey: "isList")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "isList") {
            toolbarMode = .list
        } else {
            toolbarMode = .collect
        }
        setup()
    }

    func setup() {
        if toolbarMode == .collect {
            setupCollect()
        } else {
            setupList()
        }
        self.backgroundColor = UIColor.white
        self.barStyle = .default
        self.clipsToBounds = true
        self.barTintColor = UIColor.white
        //        //角丸をつける
        //        let maskPath = UIBezierPath(roundedRect: bounds,
        //                                    byRoundingCorners: [.topLeft, .topRight],
        //                                    cornerRadii: CGSize(width:10,height:10))
        //        let maskLayer = CAShapeLayer()
        //        maskLayer.frame = bounds
        //        maskLayer.path = maskPath.cgPath
        //        self.layer.mask = maskLayer
    }

    func setupCollect() {
        slider = UISlider(frame: CGRect(x: 0, y: 0, width: self.frame.width * 2 / 5, height: self.frame.height))
        slider.minimumValue = 30.0
        slider.maximumValue = Float(self.frame.width / 2) - 45
        let value = UserDefaults.standard.float(forKey: "IconSize")
        slider.value = value == 0 ? 50.0 : value
        slider.tag = 100
        let sliderView = UIBarButtonItem(customView: slider)

        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let listBtn = UIBarButtonItem(image: UIImage(named: "list2.png"), style: .plain, target: self, action: #selector(self.changeMode(sender:)))

        let smallIcon = UIBarButtonItem(image: UIImage(named: "small.png"), style: .plain, target: nil, action: nil)
        let bigIcon = UIBarButtonItem(image: UIImage(named: "big.png"), style: .plain, target: self, action: nil)
        let flexibleIcon = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        smallIcon.tintColor = UIColor.lightGray
        bigIcon.tintColor = UIColor.lightGray

        listBtn.tag = 5
        self.items = [smallIcon, sliderView, bigIcon, flexible, flexibleIcon, flexible, listBtn]

        if sliderDelegate != nil {
            slider.addTarget(sliderDelegate, action: #selector(sliderDelegate.sliderValueChanged(sender:)), for: .valueChanged)
        }
    }

    func setupList() {
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        let listBtn = UIBarButtonItem(image: UIImage(named: "collect.png"), style: .plain, target: self, action: #selector(self.changeMode(sender:)))
        listBtn.tag = 10
        self.items = [flexible, listBtn]
    }

    @objc func changeMode(sender: UIBarButtonItem) {
        if sender.tag == 5 {
            //コレクト表示からリスト表示に変更
            setupList()
            self.toolbarMode = .list
            sliderDelegate.collectionView.appDelegate.baseVC.basePageVC.setToolbarItems(self.items, animated: false)
            //            if sliderDelegate != nil {
            //                sliderDelegate.collectionView.mode = .list
            //            }
        } else {
            //リスト表示からコレクト表示に変更
            setupCollect()
            self.toolbarMode = .collect
            sliderDelegate.collectionView.appDelegate.baseVC.basePageVC.setToolbarItems(self.items, animated: false)
            //            if sliderDelegate != nil {
            //                sliderDelegate.collectionView.mode = .collect
            //            }
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            if hitView.tag == 100 {
                return hitView
            }
            //ボタンを押しているかどうか
            if hitView.tintColor != UIColor.lightGray && hitView.frame.width > 40 {
                return hitView
            }
        }
        return nil
    }
}
