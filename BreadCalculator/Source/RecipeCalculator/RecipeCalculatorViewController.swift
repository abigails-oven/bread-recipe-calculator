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


    func endEditingField() {
        if let textField = self.view.firstResponder as? UITextField {
            self.textFieldDidEndEditing(textField)
            textField.resignFirstResponder()
        }
    }

    func setBreadType(_ breadType: BreadType, title: String, hideStage2Separator: Bool, fieldsData: RecipeCalculatorViewData, animated: Bool) {

        let index = self.breadTypes.firstIndex(of: breadType)!
        self.breadTypeControl.selectedSegmentIndex = index

        self.titleLabel.text = title
        self.stage2SeparatorLabel.isHidden = hideStage2Separator

        _setFieldsData(fieldsData)

        // Do not animate the changes
        guard animated else {
            self.view.layoutIfNeeded()
            return
        }

        // Animate the changes
        UIView.animate(withDuration: LAYOUT_ANIMATION_DURATION) {
            self.view.layoutIfNeeded()
        }
    }

    func setFieldsData(_ fieldsData: RecipeCalculatorViewData, animated: Bool) {
        _setFieldsData(fieldsData)
    }


    // MARK: - Fields Data


    private func _setFieldsData(_ fieldsData: RecipeCalculatorViewData) {

        self.loafCountField.text = fieldsData.loafCount
        self.loafWeightField.text = fieldsData.loafWeight

        for ingredient in IngredientType.all {

            // Get ingredient data
            let strings = fieldsData.ingredientStringsByType[ingredient]

            // Get controls
            let (container, label, percentageField, quantityField) = self.controls(for: ingredient)

            // Update controls with data
            container?.isHidden = (strings == nil)
            label?.text = strings?.name
            percentageField.text = strings?.percentage
            quantityField.text = strings?.quantity
        }
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

        // Do nothing if text did not change
        guard (textField.text != self.lastFieldValue) else {
            return
        }

        switch textField {
        case self.loafCountField:
            self.presenter.userDidChangeLoafCount(textField.text)

        case self.loafWeightField:
            self.presenter.viewDidChangeLoafWeight(textField.text)

        default:

            guard let ingredient = self.ingredient(for: textField), let isPercentageField = self.isPercentageField(textField) else {
                return
            }

            if isPercentageField {
                self.presenter.viewDidChangePercentage(textField.text, for: ingredient)
            }
            else {
                self.presenter.viewDidChangeQuantity(textField.text, for: ingredient)
            }
        }
    }

    private var lastFieldValue: String?


    // MARK: - Controls


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

    private typealias IngredientControls = (container: UIView?, label: UILabel?, percentageField: UITextField, quantityField: UITextField)

    private func ingredient(for textField: UITextField) -> IngredientType? {

        switch textField {
        case self.flourPrimaryPercentageField, self.flourPrimaryField:
            return .flourPrimary
        case self.flourSecondaryPercentageField, self.flourSecondaryField:
            return .flourSecondary
        case self.waterStage1PercentageField, self.waterStage1Field:
            return .waterStage1
        case self.leavenPercentageField, self.leavenField:
            return .leaven
        case self.waterStage2PercentageField, self.waterStage2Field:
            return .waterStage2
        case self.saltPercentageField, self.saltField:
            return .salt
        default:
            assertionFailure("This field is not supported by this method")
            return nil
        }
    }

    private func isPercentageField(_ textField: UITextField) -> Bool? {

        switch textField {
        case self.flourPrimaryPercentageField,
             self.flourSecondaryPercentageField,
             self.waterStage1PercentageField,
             self.leavenPercentageField,
             self.waterStage2PercentageField,
             self.saltPercentageField:
            return true

        case self.flourPrimaryField,
             self.flourSecondaryField,
             self.waterStage1Field,
             self.leavenField,
             self.waterStage2Field,
             self.saltField:
            return false

        default:
            assertionFailure("This field is not supported by this method")
            return nil
        }
    }

    private func controls(for ingredient: IngredientType) -> IngredientControls {

        switch ingredient {
        case .flourPrimary: return (
            container: nil,
            label: self.flourPrimaryLabel,
            percentageField: self.flourPrimaryPercentageField,
            quantityField: self.flourPrimaryField
            )
        case .flourSecondary: return (
            container: self.flourSecondaryView,
            label: self.flourSecondaryLabel,
            percentageField: self.flourSecondaryPercentageField,
            quantityField: self.flourSecondaryField
            )
        case .waterStage1: return (
            container: nil,
            label: self.waterStage1Label,
            percentageField: self.waterStage1PercentageField,
            quantityField: self.waterStage1Field
            )
        case .waterStage2: return (
            container: self.waterStage2View,
            label: nil,
            percentageField: self.waterStage2PercentageField,
            quantityField: self.waterStage2Field
            )
        case .leaven: return (
            container: nil,
            label: nil,
            percentageField: self.leavenPercentageField,
            quantityField: self.leavenField
            )
        case .salt: return (
            container: nil,
            label: nil,
            percentageField: self.saltPercentageField,
            quantityField: self.saltField
            )
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
