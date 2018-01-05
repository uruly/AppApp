//
//  SetInfoViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2018/01/06.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class SetInfoViewController: UIViewController {
    
    var image:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let doneBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.doneBtnTapped))
        self.navigationItem.rightBarButtonItem = doneBtn
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = UIColor.white
        
        let navigationHeight:CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 56.0
        //imageViewを置く
        let imageSize:CGFloat = 150
        let imageView = EditImageView(frame: CGRect(x:0,y:navigationHeight,width:imageSize,height:imageSize))
        imageView.center = CGPoint(x:width / 2,y:navigationHeight + 150 / 2 + 30)
        //imageView.image = image
        let layer = CALayer()
        layer.frame = CGRect(x:0,y:0,width:imageSize,height:imageSize)
        layer.contents = image.cgImage
        layer.name = "image"
        //layer.masksToBounds = true
        imageView.layer.addSublayer(layer)
        self.view.addSubview(imageView)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("disappear")
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
////        if let vc = self.navigationController?.viewControllers ,vc.count - 2 >= 0{
////            self.navigationController?.popToViewController(vc[vc.count - 2], animated: true)
////        }else {
////            self.navigationController?.popToRootViewController(animated: true)
////        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

//extension SetInfoViewController:UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        print("navigationController\(navigationController.viewControllers.count)")
//        if navigationController.viewControllers.count == 4 {
//            
//        }
//    }
//}

