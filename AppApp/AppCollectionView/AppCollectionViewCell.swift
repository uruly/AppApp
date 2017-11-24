//
//  AppCollectionViewCell.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class AppCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    var imageMaskView:UIView!
    //var checkView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkImageView.image = UIImage(named:"check.png")?.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = UIColor.checkBtn()
        
        checkImageView.isHidden = true
    }

}
