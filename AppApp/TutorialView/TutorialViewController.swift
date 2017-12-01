//
//  TutorialViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/12/01.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    var pageView:TutorialPageView!
    var pageControl:UIPageControl!
    var helpView:HelpView!
    static var isFirst:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = self.view.frame.width
        let height = self.view.frame.height
        let navigationHeight:CGFloat = 80.0
        let margin:CGFloat = 15.0
        self.view.backgroundColor = UIColor.backgroundGray()
        pageView = TutorialPageView(frame: CGRect(x:0,y:navigationHeight + margin,width:width,height:height - navigationHeight - margin))
        pageView.pageDelegate = self
        self.view.addSubview(pageView)
        
        setupPageControl()
        setupNaviBtn()
        
        setupHelp()
    }
    
    func setupPageControl(){
        pageControl = UIPageControl(frame: CGRect(x:0,y:self.view.frame.height - 40,width:self.view.frame.width,height:40))
        pageControl.currentPage = 0
        pageControl.numberOfPages = 6
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.addTarget(self, action: #selector(self.pageControlTapped(sender:)), for: .touchUpInside)
        pageControl.backgroundColor = UIColor.white
        
        //影をつける
        pageControl.layer.masksToBounds = false
        pageControl.layer.shadowColor = UIColor.darkGray.cgColor
        pageControl.layer.shadowOffset = CGSize(width:1,height:-5)
        pageControl.layer.shadowRadius = 1
        pageControl.layer.shadowOpacity = 0.8
        
        //角丸をつける
        let maskPath = UIBezierPath(roundedRect: pageControl.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width:20,height:20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = pageControl.bounds
        maskLayer.path = maskPath.cgPath
        pageControl.layer.mask = maskLayer
        self.view.addSubview(pageControl)
    }
    
    func setupNaviBtn(){
        let width = self.view.frame.width
        let navigationHeight:CGFloat = 80.0
        let margin:CGFloat = 15.0
        let welcomeBtn = NaviButton(frame:CGRect(x:0,y:navigationHeight - 40 + margin,width:width / 4,height:40))
        welcomeBtn.setTitle("WELCOME", for: .normal)
        welcomeBtn.setTitleColor(UIColor.white, for: .normal)
        welcomeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        welcomeBtn.backgroundColor = UIColor.allLabel()
        welcomeBtn.addTarget(self, action: #selector(welcomeBtnTapped), for: .touchUpInside)
        self.view.addSubview(welcomeBtn)
        
        let howtoBtn = NaviButton(frame:CGRect(x:welcomeBtn.frame.maxX,y:navigationHeight - 40 + margin,width:width / 4,height:40))
        howtoBtn.setTitle("HOW TO", for: .normal)
        howtoBtn.setTitleColor(UIColor.white, for: .normal)
        howtoBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        howtoBtn.backgroundColor = UIColor.howto()
        howtoBtn.addTarget(self, action: #selector(howtoBtnTapped), for: .touchUpInside)
        self.view.addSubview(howtoBtn)
        
        let startBtn = NaviButton(frame:CGRect(x:howtoBtn.frame.maxX,y:navigationHeight - 40 + margin,width:( width / 4 ) - 20,height:40))
        startBtn.setTitle("START", for: .normal)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        startBtn.backgroundColor = UIColor.start()
        startBtn.addTarget(self,action:#selector(startBtnTapped),for:.touchUpInside)
        self.view.addSubview(startBtn)
        
        let helpBtn = NaviButton(frame:CGRect(x:startBtn.frame.maxX,y:navigationHeight - 40 + margin,width:( width / 4 ) - 30,height:40))
        helpBtn.setTitle("HELP", for: .normal)
        helpBtn.setTitleColor(UIColor.white, for: .normal)
        helpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        helpBtn.backgroundColor = UIColor.help()
        helpBtn.addTarget(self, action: #selector(helpBtnTapped), for: .touchUpInside)
        self.view.addSubview(helpBtn)

        let closeBtn = NaviButton(frame:CGRect(x:helpBtn.frame.maxX,y:navigationHeight - 40 + margin,width:50,height:40))
        closeBtn.setTitle("×", for: .normal)
        closeBtn.setTitleColor(UIColor.white, for: .normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        closeBtn.backgroundColor = UIColor.plusBackground()
        closeBtn.addTarget(self, action: #selector(closeTutorial), for: .touchUpInside)
        self.view.addSubview(closeBtn)
    }
    
    func setupHelp(){
        let width = self.view.frame.width
        let height = self.view.frame.height
        let navigationHeight:CGFloat = 80.0
        let margin:CGFloat = 15.0
        helpView = HelpView(frame: CGRect(x:0,y:navigationHeight + margin,width:width,height:height - navigationHeight - margin), style:.grouped )
        helpView.isHidden = TutorialViewController.isFirst
        self.view.addSubview(helpView)
    }
    
    @objc func welcomeBtnTapped(){
        let indexPath = IndexPath(row: 0, section: 0)
        pageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        helpView.isHidden = true
    }
    @objc func howtoBtnTapped(){
        helpView.isHidden = true
        let indexPath = IndexPath(row: 1, section: 0)
        pageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    @objc func startBtnTapped(){
        helpView.isHidden = true
        let indexPath = IndexPath(row: 5, section: 0)
        pageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    @objc func helpBtnTapped(){
        helpView.isHidden = false
    }
    

    @objc func pageControlTapped(sender:UIPageControl){
        //print(sender.currentPage)
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        pageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeTutorial(){
        dismiss(animated: true, completion: nil)
        
    }
    
}
extension TutorialViewController: TutorialPageControlDelegate{
    func movePage(count: Int) {
        self.pageControl.currentPage = count
    }

    var tutorialVC:TutorialViewController {
        return self
    }
}

class NaviButton:UIButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame )
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //角丸をつける
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width:10,height:10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        //影をつける
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:1,height:-4)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.8
    }
}
