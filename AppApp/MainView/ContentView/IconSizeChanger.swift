//
//  IconSizeChanger.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/22.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol IconSizeChangerDelegate{
    @objc func sliderValueChanged(sender:UISlider)
    var collectionView:AppCollectionView { get }
}

enum ToolbarMode {
    case collect
    case list
}


class IconSizeChanger: UIToolbar {
    
    //AppSizeを変えるスライダー
    var slider:UISlider!
    var sliderDelegate:IconSizeChangerDelegate! {
        didSet{
            if slider != nil {
                slider.addTarget(sliderDelegate, action: #selector(sliderDelegate.sliderValueChanged(sender:)), for: .valueChanged)
            }
        }
    }
    var toolbarMode:ToolbarMode! {
        didSet{
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
        if userDefaults.bool(forKey: "isList"){
            toolbarMode = .list
        }else {
            toolbarMode = .collect
        }
        setup()
    }
    
    func setup(){
        if toolbarMode == .collect {
            setupCollect()
        }else {
            setupList()
        }
    }
    
    func setupCollect(){
        slider = UISlider(frame: CGRect(x:0,y:0,width:self.frame.width / 2,height:self.frame.height))
        slider.minimumValue = 30.0
        slider.maximumValue = 150.0
        let value = UserDefaults.standard.float(forKey:"IconSize")
        slider.value = value == 0 ? 50.0 : value
        let sliderView = UIBarButtonItem(customView: slider)
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let listBtn = UIBarButtonItem(image: UIImage(named:"list.png"), style: .plain, target: self, action: #selector(self.changeMode(sender:)))
        listBtn.tag = 5
        self.items = [sliderView,flexible,listBtn]
        
        if sliderDelegate != nil {
            slider.addTarget(sliderDelegate, action: #selector(sliderDelegate.sliderValueChanged(sender:)), for: .valueChanged)
        }
    }

    func setupList(){
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let listBtn = UIBarButtonItem(image: UIImage(named:"collect.png"), style: .plain, target: self, action: #selector(self.changeMode(sender:)))
        listBtn.tag = 10
        self.items = [flexible,listBtn]
    }
    
    
    @objc func changeMode(sender:UIBarButtonItem){
        if sender.tag == 5 {
            //コレクト表示からリスト表示に変更
            setupList()
            self.toolbarMode = .list
//            if sliderDelegate != nil {
//                sliderDelegate.collectionView.mode = .list
//            }
        }else{
            //リスト表示からコレクト表示に変更
            setupCollect()
            self.toolbarMode = .collect
//            if sliderDelegate != nil {
//                sliderDelegate.collectionView.mode = .collect
//            }
        }
    }
}
