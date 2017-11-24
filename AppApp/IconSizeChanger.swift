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
}

class IconSizeChanger: UIToolbar {
    
    //AppSizeを変えるスライダー
    var slider:UISlider!
    var sliderDelegate:IconSizeChangerDelegate! {
        didSet{
            slider.addTarget(sliderDelegate, action: #selector(sliderDelegate.sliderValueChanged(sender:)), for: .valueChanged)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        slider = UISlider(frame: CGRect(x:0,y:0,width:self.frame.width / 2,height:self.frame.height))
        slider.minimumValue = 30.0
        slider.maximumValue = 200.0
        let value = UserDefaults.standard.float(forKey:"IconSize")
        slider.value = value == 0 ? 50.0 : value
        
        let sliderView = UIBarButtonItem(customView: slider)
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.items = [flexible,sliderView,flexible]
    }

//    func sliderAddTarget(){
//        slider.addTarget(sliderDelegate, action: #selector(sliderDelegate.sliderValueChanged(sender:)), for: .valueChanged)
//    }
}
