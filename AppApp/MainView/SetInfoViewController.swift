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
    var isEditView:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height
        let doneBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(self.doneBtnTapped))
        self.navigationItem.rightBarButtonItem = doneBtn
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = UIColor.white
        
        let navigationHeight:CGFloat = self.navigationController?.navigationBar.frame.maxY ?? 56.0
        //imageViewを置く
        let imageSize:CGFloat = 180
        let imageView = EditImageView(frame: CGRect(x:0,y:navigationHeight,width:imageSize,height:imageSize))
        imageView.center = CGPoint(x:width / 2,y:navigationHeight + imageSize / 2 + 30)
        
        //向き調整
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(x:0,y:0,width:image.size.width,height:image.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //レイヤーを足す
        let layer = CALayer()
        layer.frame = CGRect(x:0,y:0,width:imageSize,height:imageSize)
        layer.contents = image.cgImage
        layer.contentsGravity = kCAGravityResizeAspectFill
        layer.name = "image"
        imageView.layer.addSublayer(layer)
        
        let shadowView = UIView(frame:imageView.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.cornerRadius = 40.0
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width:1,height:1)
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowOpacity = 0.5
        self.view.addSubview(shadowView)
        self.view.addSubview(imageView)
        
        //テーブルビューをおく
        let tableView = InfoTableView(frame:CGRect(x:0,y:imageView.frame.maxY + 15,width:width,height:height - ( imageView.frame.maxY + 15 )))
        self.view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(
            tableView,
            selector: #selector(tableView.showKeyboard(notification:)),
            name: NSNotification.Name.UIKeyboardDidShow,
            object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("disappear")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isEditView {
            if let vc = self.navigationController?.viewControllers ,vc.count - 2 >= 0{
                self.navigationController?.popToViewController(vc[vc.count - 2], animated: true)
            }else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    

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

