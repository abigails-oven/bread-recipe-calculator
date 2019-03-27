//
//  RecipeCalculatorViewController.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/26/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import UIKit

class RecipeCalculatorViewController: UIViewController, UITextFieldDelegate, RecipeCalculatorViewToPresenter {

    deinit {
        self.keyboardObservers?.forEach{ NotificationCenter.default.removeObserver($0) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // The view must be configured here because the view is the Window's rootViewController.
        // This means viewDidLoad will be called before there is an opportunity to configure the view.
        RecipeCalculatorConfig(self)

        self.setupKeyboard()
        self.allTextFields.forEach{ $0.delegate = self }

        self.presenter.viewDidLoad()
    }

    var presenter: RecipeCalculatorPresenterToView!


    // MARK: - RecipeCalculatorViewToPresenter


    // Hide Fields

    func hideFlourSecondary(_ shouldHide: Bool, animated: Bool) {
        self.flourSecondaryView.isHidden = shouldHide
        if animated { self.animateLayout() }
    }

    func hideWaterStage2(_ shouldHide: Bool, animated: Bool) {
        self.waterStage2View.isHidden = shouldHide
        if animated { self.animateLayout() }
    }

    func hideStage2Separator(_ shouldHide: Bool, animated: Bool) {
        self.stage2SeparatorLabel.isHidden = shouldHide
        if animated { self.animateLayout() }
    }

    // Set Labels

    func setTitle(_ title: String, animated: Bool) {
        self.titleLabel.text = title
        if animated { self.animateLayout() }
    }

    func setFlourPrimaryName(_ name: String, animated: Bool) {
        self.flourPrimaryLabel.text = name
        if animated { self.animateLayout() }
    }

    func setFlourSecondaryName(_ name: String, animated: Bool) {
        self.flourSecondaryLabel.text = name
        if animated { self.animateLayout() }
    }

    func setWaterStage1Name(_ name: String, animated: Bool) {
        self.waterStage1Label.text = name
        if animated { self.animateLayout() }
    }

    // Get/Set Values

    var loafCount: String? {
        return self.loafCountField.text
    }

    var loafWeight: String? {
        return self.loafWeightField.text
    }

    func quantity(for ingredient: IngredientType) -> String? {
        return self.quantityField(for: ingredient).text
    }

    func percentage(for ingredient: IngredientType) -> String? {
        return self.percentageField(for: ingredient).text
    }

    func setLoafCount(_ string: String) {
        self.loafCountField.text = string
    }

    func setLoafWeight(_ string: String) {
        self.loafWeightField.text = string
    }

    func setQuantities(_ quantityByIngredient: [IngredientType : String?]) {
        for (ingredient, quantity) in quantityByIngredient {
            let field = self.quantityField(for: ingredient)
            field.text = quantity
        }
    }

    func setPercentages(_ percentageByIngredient: [IngredientType : String?]) {
        for (ingredient, percentage) in percentageByIngredient {
            let field = self.percentageField(for: ingredient)
            field.text = percentage
        }
    }

    // Set Bread Type

    func setBreadType(_ breadType: BreadType) {
        let index = self.breadTypes.firstIndex(of: breadType)!
        self.breadTypeControl.selectedSegmentIndex = index
    }


    // MARK: - BreadType Control


    /// Represents the order of the bread types in the storyboard
    /// This must match the storyboard EXACTLY
    private let breadTypes: [BreadType] = [.wheat, .kamut, .sourdough, .bran]

    @IBOutlet private weak var breadTypeControl: UISegmentedControl!

    @IBAction func didChangeBreadTypeControl(_ sender: UISegmentedControl) {
        let breadType = self.breadTypes[sender.selectedSegmentIndex]
        self.presenter.viewDidChangeBreadType(breadType)
    }


    // MARK: - UITextFieldDelegate


    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lastFieldValue = textField.text
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text != self.lastFieldValue) {
            self.presenter.viewDidChangeFieldValue()
        }
    }

    private var lastFieldValue: String?


    // MARK: - Outlets


    @IBOutlet private weak var contentScrollView: UIScrollView!

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var loafCountField: UITextField!
    @IBOutlet private weak var loafWeightField: UITextField!

    @IBOutlet private weak var flourPrimaryLabel: UILabel!
    @IBOutlet private weak var flourPrimaryPercentageField: UITextField!
    @IBOutlet private weak var flourPrimaryField: UITextField!

    @IBOutlet private weak var flourSecondaryView: UIStackView!
    @IBOutlet private weak var flourSecondaryLabel: UILabel!
    @IBOutlet private weak var flourSecondaryPercentageField: UITextField!
    @IBOutlet private weak var flourSecondaryField: UITextField!

    @IBOutlet private weak var waterStage1Label: UILabel!
    @IBOutlet private weak var waterStage1PercentageField: UITextField!
    @IBOutlet private weak var waterStage1Field: UITextField!

    @IBOutlet private weak var leavenPercentageField: UITextField!
    @IBOutlet private weak var leavenField: UITextField!

    @IBOutlet private weak var stage2SeparatorLabel: UILabel!

    @IBOutlet private weak var waterStage2View: UIStackView!
    @IBOutlet private weak var waterStage2PercentageField: UITextField!
    @IBOutlet private weak var waterStage2Field: UITextField!

    @IBOutlet private weak var saltPercentageField: UITextField!
    @IBOutlet private weak var saltField: UITextField!

    private lazy var allTextFields: [UITextField] = [
        self.loafCountField,
        self.loafWeightField,
        self.flourPrimaryPercentageField,
        self.flourPrimaryField,
        self.flourSecondaryPercentageField,
        self.flourSecondaryField,
        self.waterStage1PercentageField,
        self.waterStage1Field,
        self.leavenPercentageField,
        self.leavenField,
        self.waterStage2PercentageField,
        self.waterStage2Field,
        self.saltPercentageField,
        self.saltField
    ]


    // MARK: - UI Component for Ingredient


    private func quantityField(for ingredient: IngredientType) -> UITextField {
        switch ingredient {
        case .flourPrimary:   return self.flourPrimaryField
        case .flourSecondary: return self.flourSecondaryField
        case .waterStage1:    return self.waterStage1Field
        case .waterStage2:    return self.waterStage2Field
        case .leaven:         return self.leavenField
        case .salt:           return self.saltField
        }
    }

    private func percentageField(for ingredient: IngredientType) -> UITextField {
        switch ingredient {
        case .flourPrimary:   return self.flourPrimaryPercentageField
        case .flourSecondary: return self.flourSecondaryPercentageField
        case .waterStage1:    return self.waterStage1PercentageField
        case .waterStage2:    return self.waterStage2PercentageField
        case .leaven:         return self.leavenPercentageField
        case .salt:           return self.saltPercentageField
        }
    }


    // MARK: - Animate layout


    private func animateLayout() {
        UIView.animate(withDuration: LAYOUT_ANIMATION_DURATION) {
            self.view.layoutIfNeeded()
        }
    }


    // MARK: - Keyboard


    private func setupKeyboard() {

        // Create toolbar with done button on it

        let toolbar = UIToolbar()

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(self.didPressKeyboardDoneButton(_:))
        )

        toolbar.items = [doneButton]
        toolbar.sizeToFit()

        self.allTextFields.forEach{ $0.inputAccessoryView = toolbar }

        // Setup Keyboard observation

        let center = NotificationCenter.default
        let keyboardWillShow = UIResponder.keyboardWillShowNotification
        let keyboardWillHide = UIResponder.keyboardWillHideNotification

        self.keyboardObservers = [
            center.addObserver(forName: keyboardWillShow, object: nil, queue: nil) { notification in
                // Set the scroll view's insets so the focused text field is not covered by the keyboard
                let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let bottomOffset = keyboardRect.height + KEYBOARD_COMFORT_PADDING
                let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomOffset, right: 0)
                self.contentScrollView.contentInset = insets
                self.contentScrollView.scrollIndicatorInsets = insets
            },
            center.addObserver(forName: keyboardWillHide, object: nil, queue: nil) { notification in
                // Restore the scroll view's insets when the keyboard dismisses
                self.contentScrollView.contentInset = .zero
                self.contentScrollView.scrollIndicatorInsets = .zero
            }
        ]
    }

    private var keyboardObservers: [NSObjectProtocol]?

    @objc
    private func didPressKeyboardDoneButton(_ sender: Any) {
        self.view.firstResponder?.resignFirstResponder()
    }
}

private let KEYBOARD_COMFORT_PADDING: CGFloat = 32
private let LAYOUT_ANIMATION_DURATION: TimeInterval = 0.3
