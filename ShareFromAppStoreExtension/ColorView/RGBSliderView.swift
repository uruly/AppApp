//
//  RGBSliderView.swift
//  ColorView
//
//  Created by 久保　玲於奈 on 2017/11/30.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

@objc protocol ColorDelegate {
    func setColor(color: UIColor)
}

class RGBSliderView: UIView {

    var view: UIView!
    var redSlider: UISlider!
    var greenSlider: UISlider!
    var blueSlider: UISlider!
    weak var colorDelegate: ColorDelegate!
    var color: UIColor! {
        didSet {
            print("ここ呼ばれているよ")
            self.view.backgroundColor = color
            if colorDelegate != nil {
                colorDelegate.setColor(color: color)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        setup()
    }

    func setup() {
        let margin: CGFloat = 15
        view = UIView(frame: CGRect(x: margin, y: margin, width: 50, height: 50))
        view.backgroundColor = UIColor.yellow
        view.layer.cornerRadius = 10.0
        //影をつける
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5

        self.addSubview(view)

        let labelMinX = view.frame.maxX + margin
        let redLabel = UILabel(frame: CGRect(x: labelMinX, y: margin, width: 50, height: 50))
        redLabel.font = UIFont.boldSystemFont(ofSize: 14)
        redLabel.text = "R"
        redLabel.textAlignment = .center
        redLabel.textColor = UIColor.red
        self.addSubview(redLabel)

        //green
        let greenLabel = UILabel(frame: CGRect(x: labelMinX, y: redLabel.frame.maxY, width: 50, height: 50))
        greenLabel.font = UIFont.boldSystemFont(ofSize: 14)
        greenLabel.text = "G"
        greenLabel.textAlignment = .center
        greenLabel.textColor = UIColor.green
        self.addSubview(greenLabel)

        //blue
        let blueLabel = UILabel(frame: CGRect(x: labelMinX, y: greenLabel.frame.maxY, width: 50, height: 50))
        blueLabel.font = UIFont.boldSystemFont(ofSize: 14)
        blueLabel.text = "B"
        blueLabel.textAlignment = .center
        blueLabel.textColor = UIColor.blue
        self.addSubview(blueLabel)

        let sliderMinX = redLabel.frame.maxX + margin
        let sliderWidth: CGFloat = 200
        redSlider = UISlider(frame: CGRect(x: sliderMinX, y: margin, width: sliderWidth, height: 50))
        redSlider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        redSlider.minimumTrackTintColor = UIColor.red
        redSlider.tag = 1
        redSlider.minimumValue = 0
        redSlider.maximumValue = 255
        redSlider.value = 50
        self.addSubview(redSlider)

        greenSlider = UISlider(frame: CGRect(x: sliderMinX, y: redSlider.frame.maxY, width: sliderWidth, height: 50))
        greenSlider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        greenSlider.minimumTrackTintColor = UIColor.green
        greenSlider.tag = 2
        greenSlider.minimumValue = 0
        greenSlider.maximumValue = 255
        greenSlider.value = 255
        self.addSubview(greenSlider)

        blueSlider = UISlider(frame: CGRect(x: sliderMinX, y: greenSlider.frame.maxY, width: sliderWidth, height: 50))
        blueSlider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        blueSlider.minimumTrackTintColor = UIColor.blue
        blueSlider.tag = 3
        blueSlider.minimumValue = 0
        blueSlider.maximumValue = 255
        blueSlider.value = 200
        self.addSubview(blueSlider)

        color = UIColor(red: 50 / 255, green: 255 / 255, blue: 200 / 255, alpha: 1)
    }

    @objc func sliderValueChanged(sender: UISlider) {
        guard let current = color.cgColor.components else {
            print("ここ")
            return
        }
        print(current)
        if sender.tag == 1 { //red
            color = UIColor(red: CGFloat(sender.value) / 255, green: current[1], blue: current[2], alpha: 1)
        } else if sender.tag == 2 { //green
            color = UIColor(red: current[0], green: CGFloat(sender.value) / 255, blue: current[2], alpha: 1)
        } else { //blue
            color = UIColor(red: current[0], green: current[1], blue: CGFloat(sender.value) / 255, alpha: 1)
        }
    }

}
