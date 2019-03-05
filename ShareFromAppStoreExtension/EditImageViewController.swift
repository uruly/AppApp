//
//  EditImageViewController.swift
//  ShareFromAppStoreExtension
//
//  Created by 久保　玲於奈 on 2018/01/10.
//  Copyright © 2018年 Reona Kubo. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {

    var imageView:EditImageView!
    var image:UIImage!
    var textLabel:UILabel!
    var shareVC:ShareViewController!
    var position:CGPoint?
    var scale:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blue
        let width = self.view.bounds.width
        //imageViewを置く
        let imageSize:CGFloat = 180
        imageView = EditImageView(frame:CGRect(x:0,y:15,width:imageSize,height:imageSize))
        imageView.center = CGPoint(x:width / 2 - 15,y:15 + imageSize / 2)
        
        //向き調整
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        image.draw(in: CGRect(x:0,y:0,width:image.size.width,height:image.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //レイヤーを足す
        let layer = CALayer()
        layer.frame = CGRect(x:0,y:0,width:imageSize,height:imageSize)
        layer.contents = image.cgImage
        layer.contentsGravity = CALayerContentsGravity.resizeAspectFill
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
        // Do any additional setup after loading the view.
        
        //ラベルを表示
        textLabel = UILabel(frame:CGRect(x:0,y:imageView.frame.maxY + 15,width:width,height:50))
        textLabel.text = "ドラッグ・ピンチイン/アウトで調整"
        textLabel.font = UIFont.systemFont(ofSize: 14.0)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.gray
        self.view.addSubview(textLabel)
        
        //print("subview\(shareVC)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize:CGFloat = 180.0
        imageView.center = CGPoint(x:self.view.frame.width / 2,y:15 + imageSize / 2)
        textLabel.frame = CGRect(x:0,y:imageView.frame.maxY + 15,width:self.view.frame.width,height:50)
        if scale != nil && position != nil {
            updateImagePosition()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            var existsSelfInViewControllers = true
            for viewController in viewControllers {
                if viewController == self {
                    existsSelfInViewControllers = false
                    // selfが存在した時点で処理を終える
                    break
                }
            }
            
            if existsSelfInViewControllers {
                //print("前の画面に戻る処理が行われました")
                self.saveImage()
            }
        }
        super.viewWillDisappear(animated)
    }
    
    func updateImagePosition() {
        if let layer = imageView.layer.sublayers?.first {
            layer.position = position!
            layer.setAffineTransform(CGAffineTransform(scaleX: scale!,y:scale!))
        }
    }
    
    func saveImage(){
        let cropImage = imageView.snapshot()
        let imageData = cropImage.pngData()!
        shareVC.image = imageData
        shareVC.scale = imageView.effectiveScale
        if let layer = imageView.layer.sublayers?.first {
            shareVC.position = layer.position
        }
        //print("saveしてるよ")
        //print("プレビューアクション相手ｍす\(shareVC.previewActionItems)")
        //print("shareVC.loadPreviewView\(shareVC.loadPreviewView())")
        if let view = shareVC.loadPreviewView(){
            //print(view)
            if let preview = view.subviews.first as? UIImageView {
                //print("preview")
                preview.image = cropImage
            }
            //print("imageView.subviews:\(view.subviews),imageView:isKind\(preview)")
            //imageView.image = cropImage
        }
        
        
    }

}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.clear.cgColor)
        context.setShouldAntialias(true)
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let png = image.pngData()!
        let pngImage = UIImage(data: png)!
        return pngImage
    }
}
