//
//  BasePageViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/21.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//
// メイン画面のページビューコントローラ

import UIKit

protocol BasePageViewControllerDelegate {
    var basePageVC:BasePageViewController { get }
}


class BasePageViewController: UIPageViewController {
    
    var isInfinity = false //無限スクロールにするかどうか
    var appLabel:AppLabel!
    var selectionBar:SelectionBar!
    static var isUnwind = false
    var lastContentOffsetX:CGFloat = 0
    var currentPageIndex:Int = 0
    var nextPageIndex:Int = 0
    var isSelectionScroll = true
    //var iconSizeChanger:IconSizeChanger!
    //var editToolbar:EditToolbar!
    var isGoDetail = false
    var isAdjustTitle:Bool = false
    var bottomView:BottomView!
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle:.scroll,navigationOrientation:.horizontal,options:options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = UIColor.backgroundGray()
        appLabel = AppLabel()
        self.automaticallyAdjustsScrollViewInsets = false
        //ナビゲーションバーをカスタマイズ
        self.title = ""
        //let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editTapped(sender:)))
        let editBtn = UIBarButtonItem(title: "選択", style: .plain, target: self, action: #selector(self.editTapped(sender:)))
        self.navigationItem.rightBarButtonItem = editBtn
        
        let tutorial = UIBarButtonItem(image: UIImage(named:"tutorialMark.png")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.showTutorial))

        self.navigationItem.leftBarButtonItem = tutorial
        let navigationBarHeight = self.navigationController?.navigationBar.frame.maxY ?? 56
        //let statusBarHeight = UIApplication.shared.statusBarFrame.height
        //ロゴを乗せる
        let titlePath = Bundle.main.path(forResource: "logo3", ofType: "png")
        let titleLogo =  UIImageView(image: UIImage(contentsOfFile:titlePath!)?.withRenderingMode(.alwaysTemplate))
        titleLogo.frame = CGRect(x:(width - 200) / 2,y:-10,width:200,height:navigationBarHeight)
        titleLogo.contentMode = .scaleAspectFit
        titleLogo.tintColor = UIColor.darkGray
        titleLogo.tag = 255
        self.navigationController?.navigationBar.addSubview(titleLogo)
        //let titleLoboBtn = UIBarButtonItem(customView: titleLogo)
        //self.navigationItem.titleView = titleLogo
        
        //セレクションバーを配置
        selectionBar = SelectionBar(frame:CGRect(x:0,y:navigationBarHeight,width:width,height:55),pageVC:self)
        self.view.addSubview(selectionBar)
        
//        //toolbarを配置
//        let toolbarHeight = self.navigationController?.toolbar.frame.height ?? 44
//        iconSizeChanger = IconSizeChanger(frame:CGRect(x:0,
//                                                       y:height - toolbarHeight,
//                                                       width:width,
//                                                       height:toolbarHeight))
//        //self.view.addSubview(iconSizeChanger)
//        self.navigationController?.setToolbarHidden(false, animated: false)
//
//        self.setToolbarItems(iconSizeChanger.items, animated: false)
//        //print(self.navigationController?.toolbar.items)
//        //同じ位置にEditToolbarを配置
//        editToolbar = EditToolbar(frame: iconSizeChanger.frame)
        
        //bottomMenuを配置
        let handleHeight:CGFloat = 15.0
        var bottomViewHeight:CGFloat = height - width + handleHeight
        print("bottomViewHeight\(bottomViewHeight)")
        if bottomViewHeight < 300 {
            bottomViewHeight = 310
        }
        bottomView = BottomView(frame: CGRect(x:0,y:height - bottomViewHeight,width:width,height:bottomViewHeight))
        bottomView.delegate = self
        self.view.addSubview(bottomView)
        
        if appLabel.array.count > 0 {
            self.setViewControllers([getBase(appLabel: appLabel.array[0])], direction: .forward, animated: true, completion: nil)
        }
        self.dataSource = self
        self.delegate = self as UIPageViewControllerDelegate
        
        let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.delegate = self
        isAdjustTitle = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if BasePageViewController.isUnwind{
            //print("truedayo")
            appLabel.reloadLabelData()
            selectionBar.reloadData()
            selectionBar.collectionViewLayout.invalidateLayout()
            if !appLabel.array.contains(where: {$0.id == AppLabel.currentID}){
                self.setViewControllers([getBase(appLabel: appLabel.array[0])], direction: .forward, animated: false, completion: nil)
            }else {
                self.setViewControllers([getBase(appLabel: appLabel.array[AppLabel.currentOrder!])], direction: .forward, animated: false, completion: nil)
            }
            if self.navigationItem.rightBarButtonItem != nil {
                cancelEdit(sender:self.navigationItem.rightBarButtonItem!)
            }
            
            let userDefaults = UserDefaults.standard
            if !userDefaults.bool(forKey:"editLabel"){
                let rect = CGRect(x:15,y:self.selectionBar.frame.maxY,width:200,height:80)
                let balloonView = BalloonView(frame: rect,color:UIColor.help())
                balloonView.isDown = false
                balloonView.tag = 543
                balloonView.label.text = "編集したいときは\nラベルをダブルタップ"
                balloonView.label.textColor = UIColor.white
                self.view.addSubview(balloonView)
                UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat,.autoreverse,.curveEaseIn], animations: {
                    balloonView.center.y += 5.0
                }, completion: nil)
                userDefaults.set(true,forKey:"editLabel")
            }
        }else {
            appLabel.reloadLabelData()
            selectionBar.reloadData()
        }
        
//        //pickerにdelegateをつける
//        if let uploadCell = bottomView.baseView.cellForItem(at: IndexPath(row: 1, section: 0)) as? UploadViewCell {
//            uploadCell.view.delegate = self
//        }
        //self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let titleLogo = self.navigationController?.navigationBar.viewWithTag(255){
            titleLogo.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let titleLogo = self.navigationController?.navigationBar.viewWithTag(255){
            titleLogo.alpha = 0
            titleLogo.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                titleLogo.alpha = 1.0
                //titleLogo.transform.scaledBy(x: 1.5, y: 1.5)
            }, completion: { (_) in
                //titleLogo.transform.inverted()
            })
        }
        bottomMenuTutorial()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            let isiPhoneX = UIScreen.main.bounds.size == CGSize(width: 375, height: 812)
            if isiPhoneX && isAdjustTitle{
                if let titleLogo = self.navigationController?.navigationBar.viewWithTag(255){
                    titleLogo.center.y -= 10
                    isAdjustTitle = false
                }
            }
        }
    }
    
    @objc func showTutorial(){
        let tutorialVC = TutorialViewController()
        TutorialViewController.isFirst = false
        self.navigationController?.present(tutorialVC, animated: true, completion: nil)
    }

    func reloadPage(order:Int){
        self.setViewControllers([getBase(appLabel: appLabel.array[order])], direction: .forward, animated: false, completion: nil)
    }
    
    func getBase(appLabel:AppLabelData) -> BaseViewController {
        let baseView = BaseViewController()
        baseView.appLabel = appLabel
        return baseView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAppLabel(){
        let createLabelVC = CreateAppLabelViewController()
        let naviVC = UINavigationController(rootViewController: createLabelVC)
        self.present(naviVC, animated: true, completion: nil)
    }
    
    func editAppLabel(label:AppLabelData){
        if isGoDetail {
            return
        }
        isGoDetail = true
        let editLabelVC = EditAppLabelViewController()
        //今の値を入れておく
        editLabelVC.currentName = label.name
        editLabelVC.order = label.order
        editLabelVC.color = label.color
        editLabelVC.id = label.id
        editLabelVC.explain = label.explain
        
        let naviVC = UINavigationController(rootViewController: editLabelVC)
        self.present(naviVC, animated: true, completion: {
            self.isGoDetail = false
        })
    }
    
    //編集中にする
    @objc func editTapped(sender:UIBarButtonItem){
        let isWhileEditing = AppCollectionView.isWhileEditing
        //let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
        if isWhileEditing {
            //編集中を解除する
            cancelEdit(sender: sender)
        }else{
            //編集中にする
            AppCollectionView.isWhileEditing = true
            sender.title = "キャンセル"
            //スクロールできないようにする
            let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
            scrollView?.isScrollEnabled = false
            if let baseVC:BaseViewController = self.viewControllers?[0] as? BaseViewController{
                baseVC.collectionView.checkArray = []
                baseVC.collectionView.reloadData()
            }
            
            //edittoolbarを表示
            //self.navigationController?.setToolbarHidden(false, animated: false)
            self.bottomView.editToolbar.isHidden = false
            self.bottomView.toolbar.isHidden = true
            //self.setToolbarItems(editToolbar.items, animated: false)
        }
        
    }
    func cancelEdit(sender:UIBarButtonItem){
        //編集中を解除する
        AppCollectionView.isWhileEditing = false
        let scrollView = self.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.isScrollEnabled = true
        sender.title = "選択"
        if let baseVC:BaseViewController = self.viewControllers?[0] as? BaseViewController{
            baseVC.collectionView.checkArray = []
            baseVC.collectionView.reloadData()
        }
        //self.navigationController?.setToolbarHidden(false, animated: false)
        
        self.bottomView.editToolbar.isHidden = true
        self.bottomView.toolbar.isHidden = false
        //self.setToolbarItems(iconSizeChanger.items, animated: false)
    }
    
    
    func bottomMenuTutorial(){
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey:"bottomMenuTutorial"){
            let width = self.view.frame.width
            let rect = CGRect(x:30,y:self.selectionBar.frame.maxY,width:width - 60,height:200)
            let balloonView = BalloonView(frame: rect,color:UIColor.help())
            let fakeView = FakeView(frame: self.view.frame)
            self.view.addSubview(fakeView)
            balloonView.isDown = true
            balloonView.label.text = "下部メニューで壁紙の設定や\nデータをアップロードすることが\nできるようになりました！"
            balloonView.label.textColor = UIColor.white
            fakeView.addSubview(balloonView)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat,.autoreverse,.curveEaseIn], animations: {
                balloonView.center.y += 5.0
            }, completion: nil)
            userDefaults.set(true,forKey:"bottomMenuTutorial")
        }
    }
}
extension BasePageViewController: UIPageViewControllerDataSource {
    //ページが戻る
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //現在の位置で場合分け
        if viewController.isKind(of: BaseViewController.self){
            //let currentView = viewController as! BaseViewController
            let prevValue = AppLabel.currentOrder! - 1
            if(prevValue < 0){
                return self.isInfinity ? getBase(appLabel:appLabel.array.last!) : nil
            }
            return getBase(appLabel: appLabel.array[prevValue])
        }else{
            return nil
        }
    }
    
    //ページが進む
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        //現在の位置で場合分け
        if viewController.isKind(of: BaseViewController.self){
            //let currentView = viewController as! BaseViewController
            let nextValue = AppLabel.currentOrder! + 1
            if(nextValue > appLabel.array.count - 1){
                return self.isInfinity ? getBase(appLabel:appLabel.array.first!) : nil
            }
            return getBase(appLabel:appLabel.array[nextValue])
        }else{
            return nil
        }
    }
    
}
extension BasePageViewController:UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        //print("willTransiton")
        if let curVC = pageViewController.viewControllers?.first,curVC.isKind(of:BaseViewController.self){
            let currentVC = curVC as! BaseViewController
            //print(currentVC.appLabel.name)
            self.currentPageIndex = currentVC.appLabel.order
        }
        if let neVC = pendingViewControllers.first,neVC.isKind(of: BaseViewController.self){
            let nextVC = neVC as! BaseViewController
            //print(nextVC.appLabel.name)
            self.nextPageIndex = nextVC.appLabel.order
            if fabs(Double(self.currentPageIndex - self.nextPageIndex)) > 1{
                selectionBar.diffX = 0
            }else{
                selectionBar.setDiffX(nextIndex: self.nextPageIndex)
            }
        }

    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let prevVC = previousViewControllers.first,prevVC.isKind(of: BaseViewController.self){
            //let previousVC = prevVC as! BaseViewController
            //print(previousVC.appLabel.name)
            if let curVC = pageViewController.viewControllers?.first,curVC.isKind(of:BaseViewController.self){
                let currentVC = curVC as! BaseViewController
                //print(currentVC.appLabel.name)
                self.currentPageIndex = currentVC.appLabel.order
                selectionBar.scrollAdjust(index:self.currentPageIndex)
            }
        }
        //print("っここ")
        //print("previousView\(previousViewControllers)")
    }
}

extension BasePageViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("Drag開始")
        if let view = self.view.viewWithTag(543){
            view.removeFromSuperview()
        }
        isSelectionScroll = true
        lastContentOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("スクロール中\(scrollView.contentOffset.x)")
        //ここでカテゴリバーを移動させる
        let diffX = scrollView.contentOffset.x - lastContentOffsetX
        if fabs(diffX) < 200 && isSelectionScroll{
            //selectionBar.scrollToHorizontallyCenter(index:self.nextPageIndex ,x:diffX)
        }
        lastContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("didendDrag")
        //isSelectionScroll = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //指が離れたとき、近い方にカテゴリを移動
        
    }

}

extension BasePageViewController:BottomMenuDelegate{
    var parentView: UIView {
        return self.view
    }
}

extension BasePageViewController:UploadViewDelegate{
    func presentPicker() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        self.present(pickerController, animated: true, completion: nil)
    }
}

extension BasePageViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //容量の問題をここでみてポップアップを出す
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //let image = info[UIImagePickerControllerEditedImage] as? UIImage
        //登録画面に遷移
        let setInfoVC = SetInfoViewController()
        setInfoVC.image = image
        if let url = info[UIImagePickerControllerReferenceURL] as? URL{
            //print(url.path)
            //setInfoVC.url = url
            if url.path.contains("GIF"){
                setInfoVC.isEditView = true
            }
        }
        if picker.viewControllers.contains(where: { (vc) -> Bool in
            if let _:SetInfoViewController = vc as? SetInfoViewController {
                return true
            }
            //print(vc)
            return false
        }){
            return
        }
        picker.pushViewController(setInfoVC, animated: true)
    }
    
}
