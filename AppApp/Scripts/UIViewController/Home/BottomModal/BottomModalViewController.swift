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
    }

    @IBAction func valueChangedSlider(_ sender: UISlider) {

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
    }

}
