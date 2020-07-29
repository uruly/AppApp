//
//  PageViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/28.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate: class {
    var nextLabel: Label? { get }
    var prevLabel: Label? { get }
    func setCurrentPage(_ tag: Int)
}

final class PageViewController: UIPageViewController {

    weak var pageDelegate: PageViewControllerDelegate?
    var currentPage: Int = 0
    var isDuringAnimation: Bool = true

    // MARK: - Initializer

    init(first viewController: UIViewController) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private method

    private func setup() {
        delegate = self
        dataSource = self
    }

}

// MARK: - UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        isDuringAnimation = true
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        isDuringAnimation = false
        guard let topViewController: AppsViewController = pageViewController.viewControllers?.first as? AppsViewController, completed else { return }
        currentPage = topViewController.label.order
        pageDelegate?.setCurrentPage(topViewController.label.order)
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageDelegate = pageDelegate, let prevLabel = pageDelegate.prevLabel else { return nil }
        return AppsViewController(label: prevLabel)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageDelegate = pageDelegate, let nextLabel = pageDelegate.nextLabel else { return nil }
        return AppsViewController(label: nextLabel)
    }
}
