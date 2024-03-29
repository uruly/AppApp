//
//  WebViewController.swift
//  AppApp
//
//  Created by 久保　玲於奈 on 2017/11/27.
//  Copyright © 2017年 Reona Kubo. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var searchWord: String = ""
    var webView: WKWebView!
    var toolbar: WebPageToolbar!
    var lastContentOffsetY: CGFloat = 0
    var indicator: PassThroughIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = R.color.whiteFlowerColor()!
        let toolBarHeight: CGFloat = 44.0
        let width = self.view.frame.width
        let height = self.view.frame.height

        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        webView.scrollView.contentInset.bottom = toolBarHeight
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.delegate = self
        webView.allowsBackForwardNavigationGestures = true

        let urlString = "https://www.google.co.jp/search?&q=\(searchWord)"
        let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        let url = NSURL(string: encodedUrlString!)
        let request = NSURLRequest(url: url! as URL)
        webView.load(request as URLRequest)
        self.view.addSubview(webView)

        indicator = PassThroughIndicator(style: .medium)
        indicator.frame = self.view.frame
        indicator.startAnimating()
        indicator.isHidden = true
        self.view.addSubview(indicator)

        // ツールバーを表示
        toolbar = WebPageToolbar(frame: CGRect(x: 0, y: height - toolBarHeight, width: width, height: toolBarHeight))
        let back = UIBarButtonItem(image: R.image.left_arrow()!, style: .plain, target: self, action: #selector(goBack))
        let forward = UIBarButtonItem(image: R.image.right_arrow()!, style: .plain, target: self, action: #selector(goForward))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshView))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        back.tintColor = UIColor.lightGray
        forward.tintColor = UIColor.lightGray
        let safari = UIBarButtonItem(image: R.image.safari()!, style: .plain, target: self, action: #selector(goSafari))
        toolbar.items = [back, flexible, forward, flexible, refresh, flexible, safari]
        self.setToolbarItems(toolbar.items, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: true)
        // self.view.addSubview(toolbar)

    }

    @objc func goBack() {
        if self.webView.canGoBack {
            let transition: CATransition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromLeft
            transition.duration = 0.3
            self.webView.layer.add(transition, forKey: nil)
            self.webView.goBack()
            self.resetToolbar()
        }
    }

    func resetToolbar() {
        if let item = toolbar?.items?[0] {
            if self.webView.canGoBack {
                item.tintColor = nil
            } else {
                item.tintColor = UIColor.lightGray
            }
        }
        if let item = toolbar?.items?[1] {
            if self.webView.canGoForward {
                item.tintColor = nil
            } else {
                item.tintColor = UIColor.lightGray
            }
        }
    }

    @objc func goForward() {
        if self.webView.canGoForward {
            let transition: CATransition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1.0
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            transition.duration = 0.3
            self.webView.layer.add(transition, forKey: nil)
            self.webView.goForward()
            self.resetToolbar()
        }
    }

    @objc func refreshView() {
        self.webView.reload()
    }

    @objc func goSafari() {
        if let url = webView.url {
            let app: UIApplication = UIApplication.shared
            app.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }

}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.indicator.startAnimating()
        self.indicator.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.resetToolbar()
        self.indicator.isHidden = true
        self.indicator.stopAnimating()

    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // print("commit")
        self.resetToolbar()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        let urlString = ((url) != nil) ? url!.absoluteString : ""
        // print("ここ")
        if isMatch(input: urlString, pattern: "\\/\\/itunes\\.apple\\.com\\/") {
            // AppStoreのリンクなら、ストアアプリで開く
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            decisionHandler(WKNavigationActionPolicy.cancel)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }

    // MARK: - 正規表現でマッチング
    func isMatch(input: String, pattern: String) -> Bool {
        let regex = try! NSRegularExpression( pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex.matches( in: input, options: [], range: NSRange(location: 0, length: input.count) )
        return matches.count > 0
    }
}
extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // print("ここ")
        guard let url = navigationAction.request.url else {
            // print("nil")
            return nil
        }

        guard let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame else {
            webView.load(URLRequest(url: url))
            return nil
        }
        return nil
    }

}

extension WebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("offsetY\(scrollView.contentOffset.y)")
        let maxY = self.view.frame.maxY
        let toolBarHeight: CGFloat = 44.0
        let middleHeight = toolBarHeight / 2
        let minY = maxY - ( middleHeight * 2 )
        let diffX = abs(lastContentOffsetY - scrollView.contentOffset.y)
        let frameMinY = self.toolbar.frame.minY
        // let frameMaxY = self.toolbar.frame.maxY
        // let currentFrameCenterY = self.toolbar.center.y

        if scrollView.contentOffset.y > 0 {
            if scrollView.contentOffset.y > lastContentOffsetY {
                // どんどん非表示
                if ( frameMinY + diffX ) >= maxY {
                    // 非表示で固定
                    self.toolbar.center.y = maxY + middleHeight
                } else {
                    // 移動させる
                    self.toolbar.center.y += diffX
                }
            } else {
                // どんどん表示
                if ( frameMinY + diffX ) <= minY || frameMinY <= minY {
                    // 表示で固定
                    self.toolbar.center.y = minY + middleHeight
                } else {
                    // 移動させる
                    self.toolbar.center.y -= diffX
                }
            }
        } else {
            // 表示で固定
            self.toolbar.center.y = minY + middleHeight
        }
        lastContentOffsetY = scrollView.contentOffset.y
        // self.appDelegate.baseVC.basePageVC.iconSizeChanger.isHidden = true
    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
