//
//  BaseNavigationViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//
// ベースとなるナビゲーションバー

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.white
        let pageView = BasePageViewController()
        self.viewControllers = [pageView]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
//        
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        VersionManager.checkVersion()
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey:"FirstLaunch"){
            let tutorialVC = TutorialViewController()
            //print("First")
            self.present(tutorialVC, animated: true, completion: nil)
            userDefaults.set(true,forKey:"FirstLaunch")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    override var toolbar: UIToolbar! {
//        get {
//            return self.toolbar
//        }
//        set {
//            self.toolbar = newValue
//        }
//    }

}
