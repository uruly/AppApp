//
//  LabelCollectionViewController.swift
//  AppApp
//
//  Created by Reona Kubo on 2020/07/28.
//  Copyright © 2020 Reona Kubo. All rights reserved.
//

import UIKit

protocol LabelCollectionViewControllerDelegate: class {
    func change(_ nextLabel: Label)
    func update(_ labels: [Label], index: Int)
}

final class LabelCollectionViewController: UICollectionViewController {

    private enum CellType: Int {
        case label = 0
        case add

        static var count: Int = 2
    }

    var labels: [Label] = []
    var origLabels: [Label]?
    var currentIndex: Int = 0 {
        didSet {
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    private var isMovingEnabled: Bool = true

    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        gesture.allowableMovement = 10
        gesture.minimumPressDuration = 0.5
        return gesture
    }()

    weak var labelDelegate: LabelCollectionViewControllerDelegate?

    private let errorFeedbackGenerator: UINotificationFeedbackGenerator = {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        return generator
    }()

    // MARK: - Initializer

    init(labels: [Label]) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.labels = labels
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private method

    private func setup() {
        collectionView.register(R.nib.labelCollectionViewCell)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
    }

    private func cancelMoved() {
        collectionView.cancelInteractiveMovement()
        if let origLabels = origLabels {
            labels = origLabels
            collectionView.reloadSections(IndexSet(integer: 0))
        }
        errorFeedbackGenerator.notificationOccurred(.error)
    }
}

// MARK: - UICollectionViewDataSource

extension LabelCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CellType.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = CellType(rawValue: section) else { return 0 }
        switch type {
        case .label:
            return labels.count
        case .add:
            return 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.labelCollectionViewCell, for: indexPath)!
        guard let type = CellType(rawValue: indexPath.section) else { return cell }
        switch type {
        case .label:
            cell.label = labels[indexPath.item]
            cell.delegate = self
        case .add:
            cell.configureAddButton()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension LabelCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LabelCollectionViewCell, let type = CellType(rawValue: indexPath.section) else { return }
        switch type {
        case .label:
            guard let nextLabel = cell.label, nextLabel != labels[currentIndex] else { return }
            labelDelegate?.change(nextLabel)
            currentIndex = nextLabel.order
        case .add:
            // ラベルの設定画面に移動
            //            guard !showRewardAdIfNeeded() else { return }
            toSettingLabelViewController(label: nil, isNew: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,
                                 to destinationIndexPath: IndexPath) {
        //        if longPressGestureRecognizer.state == .ended {
        //            return
        //        }
        //        labels.swapAt(sourceIndexPath.item, destinationIndexPath.item)
        //        do {
        //            try Label.update(order: sourceIndexPath.item, label: labels[sourceIndexPath.item])
        //            try Label.update(order: destinationIndexPath.item, label: labels[destinationIndexPath.item])
        //        } catch {
        //            print("update失敗", error)
        //        }
        //        origLabels = labels
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.item > 0 && indexPath.section == 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath,
                                 toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.section == 1 {
            return IndexPath(item: labels.count - 1, section: 0)
        } else if proposedIndexPath.row == 0 {
            return IndexPath(item: 1, section: 0)
        }
        return proposedIndexPath
    }
}

extension LabelCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 { return CGSize(width: 50, height: collectionView.bounds.height) }
        let cellHeight = collectionView.bounds.height
        let text = labels[indexPath.item].name
        let width = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .bold)]).width
        let cellSize = CGSize(width: width + 32, height: cellHeight)
        return cellSize
    }

}

// MARK: - UIGestureRecognizer target

extension LabelCollectionViewController {

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)), isMovingEnabled else { break }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            isMovingEnabled = false
            origLabels = labels
        case .changed:
            var position = gesture.location(in: gesture.view)
            // 縦に動かないように調整
            position.y = collectionView.bounds.height / 2
            collectionView.updateInteractiveMovementTargetPosition(position)
        case .ended:
            isMovingEnabled = true
            guard let nextIndexPath = collectionView.indexPathForItem(at: gesture.location(in: gesture.view)), nextIndexPath.section == 0 && nextIndexPath.item != 0 else {
                cancelMoved()
                break
            }
            collectionView.endInteractiveMovement()
            collectionView.performBatchUpdates({
                collectionView.reloadSections(IndexSet(integer: 0))
            }, completion: nil)
            labelDelegate?.update(labels, index: nextIndexPath.item)
        default:
            isMovingEnabled = true
            cancelMoved()
            collectionView.cancelInteractiveMovement()
        }
    }

}

// MARK: - LabelCollectionViewCellDelegate

extension LabelCollectionViewController: LabelCollectionViewCellDelegate {

    func toSettingLabelViewController(label: Label?, isNew: Bool) {
        //        let viewController = LabelSettingViewController(label, type: isNew ? .new : .edit) { [weak self] isDelete in
        //            guard let wself = self else { return }
        //            if isDelete {
        //                wself.labels = Label.getAll()
        //                wself.collectionView.reloadData()
        //                wself.labelDelegate?.update(wself.labels, index: 0)
        //                return
        //            }
        //            let oldLabels = wself.labels
        //            wself.labels = Label.getAll()
        //            wself.collectionView.reloadData(with: BatchUpdates.setup(oldItems: oldLabels, newItems: wself.labels), target: 0)
        //            // 最新のものにフォーカスを当てる
        //            if isNew {
        //                wself.labelDelegate?.update(wself.labels, index: wself.labels.count - 1)
        //            }
        //        }
        //        let type = isNew ? "new" : "edit"
        //        let navigationController = UINavigationController(rootViewController: viewController)
        //        navigationController.modalPresentationStyle = .fullScreen
        //        present(navigationController, animated: true, completion: nil)
    }

}
