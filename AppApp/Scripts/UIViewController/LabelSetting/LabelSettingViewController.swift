//
//  LabelSettingViewController.swift
//  OKAIMO
//
//  Created by Reona Kubo on 2019/06/12.
//  Copyright © 2019 Reona Kubo. All rights reserved.
//

import UIKit

protocol LabelSettingTextFieldDelegate: class {
    func closeKeyboard(_ alertEnabled: Bool)
    var labelName: String? { get }
}

final class LabelSettingViewController: UIViewController {

    enum SettingType {
        case new
        case edit

        var title: String {
            switch self {
            case .new:
                return "新規作成"
            case .edit:
                return "編集"
            }
        }
    }
    enum CellType {
        case textField
        case colorView
        case navigation

        func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
            switch self {
            case .textField:
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.labelSettingTextFieldTableViewCell, for: indexPath)
            case .colorView:
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.labelSettingColorTableViewCell, for: indexPath)
            case .navigation:
                return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.labelSettingAdditionalTableViewCell, for: indexPath)
            }
        }
    }
    enum Section: Int {
        case labelName = 0
        case color
        case additionalApp

        static var count: Int {
            return additionalApp.rawValue + 1
        }

        var title: String {
            switch self {
            case .labelName:
                return ""
            case .color:
                return "カラー"
            case .additionalApp:
                return "Appを追加"
            }
        }

        var type: CellType {
            switch self {
            case .labelName:
                return .textField
            case .color:
                return .colorView
            case .additionalApp:
                return .navigation
            }
        }

    }

    let type: SettingType
    let label: Label

    var apps: [App]

    private let dismissCompletion: ((Bool) -> Void)?  // (削除したかどうか) -> Void

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.labelSettingColorTableViewCell)
            tableView.register(R.nib.labelSettingTextFieldTableViewCell)
            tableView.register(R.nib.labelSettingAdditionalTableViewCell)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBOutlet private weak var deleteButton: UIButton! {
        didSet {
            deleteButton.isHidden = label.id == .allLabel
        }
    }

    private var color: Color

    private let mediumFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        return generator
    }()

    weak var textFieldDelegate: LabelSettingTextFieldDelegate?

    // MARK: - Initializer

    init(_ label: Label?, type: SettingType, dismissCompletion: ((Bool) -> Void)? = nil) {
        let order = label?.order ?? Label.count
        let color = label?.uiColor ?? UIColor.getRandomColor()
        let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        self.label = label ?? Label(id: UUID().uuidString, name: "", color: colorData, order: order, explain: "")
        self.color = Color(uiColor: color)
        if let apps = label?.apps {
            self.apps = Array(apps)
        } else {
            self.apps = []
        }
        self.type = type
        self.dismissCompletion = dismissCompletion
        super.init(nibName: R.nib.labelSettingViewController.name, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        NotificationCenter.default.addObserver(self, selector: #selector(selectColor(notification:)), name: .labelColor, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard type == .new, let cell = tableView.visibleCells.first(where: {$0 is LabelSettingTextFieldTableViewCell}) as? LabelSettingTextFieldTableViewCell else { return }
        cell.textField.becomeFirstResponder()
    }

    // MARK: - Private method

    private func setupNavigationBar() {
        title = type.title
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(onTapCancelButton(_:)))
        let saveButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(onTapSaveButton(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.isEnabled = type == .edit
    }

    // MARK: - IBAction target

    @IBAction func onTapDeleteLabelButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "ラベル削除", message: "ラベルを削除します。", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "削除", style: .destructive) { [weak self] (_) in
            guard let wself = self else { return }
            do {
                try Label.remove(wself.label)
            } catch {
                print("error", error)
            }
            self?.dismissCompletion?(true)
            wself.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Notification

    @objc func selectColor(notification: Notification) {
        guard let color = notification.object as? Color else {
            fatalError("Color じゃないよ")
        }
        self.color = color
        tableView.reloadData()
    }
}

// MARK: - UITableViewControllerDelegate

extension LabelSettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .labelName:
            guard let cell = cell as? LabelSettingTextFieldTableViewCell else { return }
            cell.textField.becomeFirstResponder()
        case .color:
            mediumFeedbackGenerator.impactOccurred()
            let viewController = ColorPickerViewController(color: color)
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
        default:
            break
        }
        cell.isSelected = false
    }
}

// MARK: - UITableViewControllerDataSource

extension LabelSettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return label.id == .allLabel ? 2 : Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        let cell = section.type.getCell(tableView: tableView, indexPath: indexPath)!
        switch section {
        case .labelName:
            if let cell = cell as? LabelSettingTextFieldTableViewCell {
                cell.delegate = self
                let name = textFieldDelegate?.labelName ?? label.name
                cell.set(self, text: name)
            }
        case .color:
            if let cell = cell as? LabelSettingColorTableViewCell {
                cell.set(color: color.uiColor, text: section.title)
            }
        case .additionalApp:
            if let cell = cell as? LabelSettingAdditionalTableViewCell {
                cell.set(text: section.title)
            }
        }
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension LabelSettingViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textFieldDelegate?.closeKeyboard(true)
    }
}

// MARK: - UINavigationBar target

extension LabelSettingViewController {

    @objc func onTapCancelButton(_ sender: UIBarButtonItem) {
        textFieldDelegate?.closeKeyboard(false)
        dismiss(animated: true, completion: nil)
    }

    @objc func onTapSaveButton(_ sender: UIBarButtonItem) {
        saveLabel()
        textFieldDelegate?.closeKeyboard(false)
        dismiss(animated: true) { [weak self] in
            self?.dismissCompletion?(false)
        }
    }
}

// MARK: - UIGestureRecognizer target

extension LabelSettingViewController {

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        textFieldDelegate?.closeKeyboard(true)
    }
}

// MARK: - LabelSettingTextFieldTableViewCellDelegate

extension LabelSettingViewController: LabelSettingTextFieldTableViewCellDelegate {

    var currentLabel: Label {
        return label
    }

    func changedLabel(_ text: String) {
        navigationItem.rightBarButtonItem?.isEnabled = text != "" && text.count <= 15
    }
}

// MARK: - Realm

extension LabelSettingViewController {

    func saveLabel() {
        guard let name = textFieldDelegate?.labelName, let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color.uiColor, requiringSecureCoding: false) else { return }
        let newLabel = Label(id: label.id, name: name, color: colorData, order: label.order, explain: label.explain)
        do {
            try Label.add(newLabel)
            try Label.update(newLabel, apps: apps)
        } catch {
            print("Error", error)
        }
    }
}
