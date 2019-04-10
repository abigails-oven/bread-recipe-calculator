//
//  RecipeDetailViewController.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


class RecipeDetailViewController: UIViewController, RecipeDetailViewToPresenter, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    // MARK: - Init


    static func initFromStoryboard() -> RecipeDetailViewController {
        let storyboard = UIStoryboard(name: "RecipeDetailView", bundle: nil)
        return storyboard.instantiateInitialViewController() as! RecipeDetailViewController
    }


    // MARK: - UIViewController


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupKeyboard()
        self.setupTableView()

        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = self.view.backgroundColor
        navBar?.tintColor = .white

        self.presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.presenter.userDidTapBackButton()
        }
    }


    // MARK: - Module Accessors


    var presenter: RecipeDetailPresenterToView!


    // MARK: - RecipeDetailViewToPresenter


    func setIsEditing(_ isEditing: Bool) {
        self.tableView.reloadData()
    }

    func setEditButtonTitle(_ title: String?) {
        self.editButton.title = title
    }

    func setTitle(_ title: String?) {
        self.titleLabel.text = title
    }

    func setLoafCount(_ loafCount: String?) {
        self.loafCountField.text = loafCount
    }

    func setQuantityPerLoaf(_ quantityPerLoaf: String?) {
        self.quantityPerLoafField.text = quantityPerLoaf
    }

    func setQuantities(_ quantityByIndexPath: [IndexPath: String]) {

        guard let visibleIndexPaths = self.tableView.indexPathsForVisibleRows else {
            return
        }

        for indexPath in visibleIndexPaths {
            if let quantity = quantityByIndexPath[indexPath], let cell = self.visibleCell(for: indexPath) {
                cell.setQuantity(quantity)
            }
        }
    }


    // MARK: - Editing


    @IBOutlet weak var editButton: UIBarButtonItem!

    @IBAction func didTapEditButton(_ sender: UIBarButtonItem) {
        self.view.firstResponder?.resignFirstResponder()
        self.presenter.userDidTapEditButton()
    }


    // MARK: - Scroll View


    @IBOutlet private weak var contentScrollView: UIScrollView!


    // MARK: - Title


    @IBOutlet private weak var titleLabel: UILabel!


    // MARK: - Loaf Fields


    @IBOutlet private weak var loafCountField: UITextField!
    @IBOutlet private weak var quantityPerLoafField: UITextField!

    @IBAction private func didEndEditingLoafField(_ sender: UITextField) {

        switch sender {
        case self.loafCountField:
            self.presenter.userDidChangeLoafCount(self.loafCountField.text)
        case self.quantityPerLoafField:
            self.presenter.userDidChangeQuantityPerLoaf(self.quantityPerLoafField.text)
        default:
            assertionFailure("Unsupported field")
        }
    }


    // MARK: - Table View


    @IBOutlet private var tableView: UITableView!

    private func visibleCell(for indexPath: IndexPath) -> RecipeDetailIngredientCell? {
        return self.tableView.cellForRow(at: indexPath) as! RecipeDetailIngredientCell?
    }

    private func setupTableView() {
        // Prevent extra cells from showing
        self.tableView.tableFooterView = UIView()
        // Register cell
        self.tableView.register(RecipeDetailIngredientCell.nib, forCellReuseIdentifier: RecipeDetailIngredientCell.reuseId)

        let screenSize = UIScreen.main.bounds.size

        // Calculate row height
        let cell = RecipeDetailIngredientCell.initFromNib()
        self.tableView.rowHeight = cell.systemLayoutSizeFitting(screenSize).height

        // Calculate header height
        let header = RecipeDetailStageHeader.initFromNib()
        self.tableView.sectionHeaderHeight = header.systemLayoutSizeFitting(screenSize).height
    }


    // MARK: - UITableViewDataSource


    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfStages
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = self.dequeueHeaderView(forSection: section)
        view.setKeyboardToolbar(self.keyboardToolbar)
        self.presenter.configure(view, at: section)
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfIngredients(forStage: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailIngredientCell.reuseId, for: indexPath) as! RecipeDetailIngredientCell
        cell.backgroundColor = .clear
        cell.setKeyboardToolbar(self.keyboardToolbar)
        self.presenter.configure(cell, at: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.presenter.canEditCell(at: indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: Delete ingredient
        print("Delete \(indexPath)")
    }


    // MARK: - Header Views


    private func dequeueHeaderView(forSection section: Int) -> RecipeDetailStageHeader {

        if let view = self.headerViewBySection[section]?.reference {
            return view
        }

        let view = RecipeDetailStageHeader.initFromNib()
        self.headerViewBySection[section] = Weak(reference: view)
        return view
    }

    private var headerViewBySection: [Int: Weak<RecipeDetailStageHeader>] = [:]

    private struct Weak<T: AnyObject> {
        weak var reference: T?
    }


    // MARK: - Keyboard


    private func setupKeyboard() {

        // Add toolbar with done button to all UITextField subviews
        self.view.setKeyboardToolbar(self.keyboardToolbar)

        // Setup Keyboard observation

        let center = NotificationCenter.default
        let keyboardWillShow = UIResponder.keyboardWillShowNotification
        let keyboardWillHide = UIResponder.keyboardWillHideNotification

        self.keyboardObservers = [
            center.addObserver(forName: keyboardWillShow, object: nil, queue: nil) { [weak self] notification in
                self?.keyboardWillShow(notification)
            },
            center.addObserver(forName: keyboardWillHide, object: nil, queue: nil) { [weak self] notification in
                self?.keyboardWillHide(notification)
            }
        ]
    }


    // MARK: - Keyboard Done Button


    private lazy var keyboardToolbar: UIToolbar = {
        let toolbar = UIToolbar()

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(self.didTapKeyboardDoneButton(_:))
        )

        toolbar.items = [doneButton]
        toolbar.sizeToFit()

        return toolbar
    }()

    @objc
    private func didTapKeyboardDoneButton(_ sender: Any) {
        self.view.firstResponder?.resignFirstResponder()
    }


    // MARK: - Keyboard Observers


    private func keyboardWillShow(_ notification: Notification) {

        // Set the scroll view's insets so the focused text field is not covered by the keyboard
        let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let bottomOffset = keyboardRect.height + KEYBOARD_COMFORT_PADDING
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomOffset, right: 0)
        self.contentScrollView.contentInset = insets
        self.contentScrollView.scrollIndicatorInsets = insets
    }

    private func keyboardWillHide(_ notification: Notification) {
        // Restore the scroll view's insets when the keyboard dismisses
        self.contentScrollView.contentInset = .zero
        self.contentScrollView.scrollIndicatorInsets = .zero
    }

    private var keyboardObservers: [NSObjectProtocol]?
}


private let KEYBOARD_COMFORT_PADDING: CGFloat = 32


// MARK: - UIView: Keyboard Done Button


private extension UIView {

    /// Recursively adds the given toolbar to all descendants that are type UITextField
    func setKeyboardToolbar(_ toolbar: UIToolbar) {

        if let textField = self as? UITextField {
            textField.inputAccessoryView = toolbar
            return
        }

        for view in self.subviews {
            view.setKeyboardToolbar(toolbar)
        }
    }
}
