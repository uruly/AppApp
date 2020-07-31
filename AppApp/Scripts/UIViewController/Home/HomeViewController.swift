//
//  HomeViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/28.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    var labels: [Label] = []
    var currentIndex: Int = 0 {
        didSet {
            labelCollectionViewController?.currentIndex = currentIndex
        }
    } //  0から

    private var labelCollectionViewController: LabelCollectionViewController? {
        return children.first(where: {$0 is LabelCollectionViewController}) as? LabelCollectionViewController
    }
    private var pageViewController: PageViewController? {
        return children.first(where: {$0 is PageViewController}) as? PageViewController
    }
    private var appsViewController: AppsViewController? {
        return pageViewController?.viewControllers?.first as? AppsViewController
    }
    private var bottomViewController: BottomModalViewController? {
        return children.first(where: {$0 is BottomModalViewController}) as? BottomModalViewController
    }
    private lazy var setupLayoutOnce: Void = {
        setupLayout()
    }()

    private let mediumFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        return generator
    }()
    private let errorFeedbackGenerator: UINotificationFeedbackGenerator = {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        return generator
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // 同時タップの無効
        UIButton.appearance().isExclusiveTouch = true
        readLabel {
            setupChildren()
        }
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readLabel {
            labelCollectionViewController?.collectionView.reloadData()
            appsViewController?.collectionView.reloadData()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = setupLayoutOnce
    }

    // MARK: - Private method

    private func setupChildren() {
        guard !labels.isEmpty else { return }
        let labelViewController = LabelCollectionViewController(labels: labels)
        addChild(labelViewController)
        view.addSubview(labelViewController.view)
        labelViewController.didMove(toParent: self)
        labelViewController.labelDelegate = self

        let pageViewController = PageViewController(first: AppsViewController(label: labels.first!))
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.pageDelegate = self

        let bottomViewController = BottomModalViewController(nib: R.nib.bottomModalViewController)
        addChild(bottomViewController)
        view.addSubview(bottomViewController.view)
        bottomViewController.didMove(toParent: self)
    }

    private func setupLayout() {
        let safeAreaTop = view.safeAreaInsets.top
        let bottomViewHeight = 52 + view.safeAreaInsets.bottom
        labelCollectionViewController?.view.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(35)
            $0.top.equalToSuperview().offset(10 + safeAreaTop)
            $0.left.equalToSuperview()
        }
        pageViewController?.view.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-(45 + safeAreaTop + bottomViewHeight))
            $0.top.equalToSuperview().offset(45 + safeAreaTop)
            $0.left.equalToSuperview()
        }
        bottomViewController?.view.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalTo(0)
            $0.height.equalTo(bottomViewHeight)
        }
    }

    private func setupNavigationBar() {
        let editBtn = UIBarButtonItem(title: "選択", style: .plain, target: self, action: #selector(onTapEditButton(sender:)))
        let tutorial = UIBarButtonItem(image: R.image.tutorial_mark()!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onTapTutorialButton(sender:)))
        navigationItem.leftBarButtonItem = tutorial
        navigationItem.rightBarButtonItem = editBtn
        // TODO: - ロゴを載せる
    }

    // MARK: - IBAction

    @objc func onTapEditButton(sender: UIButton) {

    }

    @objc func onTapTutorialButton(sender: UIButton) {

    }
}

// MARK: - PageViewControllerDelegate

extension HomeViewController: PageViewControllerDelegate {

    var nextLabel: Label? {
        return labels.first(where: {$0.order == currentIndex + 1})
    }

    var prevLabel: Label? {
        return labels.first(where: {$0.order == currentIndex - 1})
    }

    func setCurrentPage(_ tag: Int) {
        currentIndex = tag
    }
}

// MARK: - LabelCollectionViewDelegate

extension HomeViewController: LabelCollectionViewControllerDelegate {

    func change(_ nextLabel: Label) {
        let viewController = AppsViewController(label: nextLabel)
        pageViewController?.setViewControllers([viewController], direction: nextLabel.order > currentIndex ? .forward : .reverse, animated: true) { [weak self] _ in
            self?.pageViewController?.isDuringAnimation = false
            self?.pageViewController?.currentPage = nextLabel.order
        }
        currentIndex = nextLabel.order
    }

    func update(_ labels: [Label], index: Int) {
        self.labels = labels
        change(labels[index])
    }
}

// MARK: - Realm

extension HomeViewController {

    private func readLabel(_ completion: (() -> Void)) {
        labels = Label.getAll()
        defer { completion() }
        guard labels.isEmpty else { return }
        // ALL labelを追加する
        guard let colorData = try? NSKeyedArchiver.archivedData(withRootObject: R.color.mainBlueColor()!, requiringSecureCoding: false) else {
            fatalError("Color Archived Error!!")
        }
        let allLabel = Label(id: "ALLLABEL", name: "ALL", color: colorData, order: 0, explain: "すべてのApp")
        labels = [allLabel]
        do {
            try Label.add(allLabel)
        } catch {
            print("Error")
        }
    }
}
