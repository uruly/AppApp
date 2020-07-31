//
//  BottomModalViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/30.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class BottomModalViewController: UIViewController {

    @IBOutlet private weak var iconSizeSlider: UISlider!
    @IBOutlet private weak var modeButton: UIBarButtonItem!

    private var mode: ToolbarMode = UserDefaults.standard.bool(forKey: .homeAppListModeIsList) ? .list : .collect

    override func viewDidLoad() {
        super.viewDidLoad()
        iconSizeSlider.isEnabled = mode == .collect
        iconSizeSlider.minimumValue = 30.0
        iconSizeSlider.maximumValue = Float(view.frame.width / 2) - 45
        let value = UserDefaults.standard.float(forKey: .homeAppListIconSize)
        iconSizeSlider.value = value == 0 ? 50.0 : value
    }

    @IBAction func valueChangedSlider(_ sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: .homeAppListIconSize)
        NotificationCenter.default.post(name: .iconSize, object: sender.value, userInfo: nil)
    }

    @IBAction func onTapModeButton(_ sender: UIBarButtonItem) {
        switch mode {
        case .collect:
            mode = .list
            sender.image = R.image.list_icon()!
            NotificationCenter.default.post(name: .toolbarMode, object: ToolbarMode.list)
        case .list:
            mode = .collect
            sender.image = R.image.collect_icon()!
            NotificationCenter.default.post(name: .toolbarMode, object: ToolbarMode.collect)
        }
        iconSizeSlider.isEnabled = mode == .collect
    }

}
