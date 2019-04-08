//
//  RecipeCalculatorPresenter.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation

class RecipeCalculatorPresenter: RecipeCalculatorPresenterToView {

    // MARK: - Init


    init(_ view: RecipeCalculatorViewToPresenter, _ interactor: RecipeCalculatorInteractorToPresenter, _ router: RecipeCalculatorRouterToPresenter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    private weak var view: RecipeCalculatorViewToPresenter!
    private let interactor: RecipeCalculatorInteractorToPresenter
    private let router: RecipeCalculatorRouterToPresenter


    // MARK: - RecipeCalculatorPresenterToView


    func viewDidLoad() {
        self.updateViewForBreadType(animated: false)
    }

    func viewDidChangeBreadType(_ breadType: BreadType) {

        self.view.endEditingField()

        self.breadType = breadType
        self.updateViewForBreadType(animated: true)
    }

    func viewDidChangeLoafCount(_ loafCountString: String?) {

        self.didChangeField(
            name: LocalizedStrings.Field.loafCountName,
            value: loafCountString,
            asNumber: { $0.int },
            save: { self.interactor.saveLoafCount($0 ?? 0, for: self.breadType) }
        )
    }

    func viewDidChangeLoafWeight(_ loafWeightString: String?) {

        self.didChangeField(
            name: LocalizedStrings.Field.loafWeightName,
            value: loafWeightString,
            asNumber: { $0.double },
            save: { self.interactor.saveLoafWeight($0 ?? 0, for: breadType) }
        )
    }

    func viewDidChangePercentage(_ percentageString: String?, for ingredient: IngredientType) {

        // Get a localized name for the field
        let ingredientName = self.breadType.name(for: ingredient)
        let fieldName = NSLocalizedString("\(ingredientName) Percentage", comment: "")

        self.didChangeField(
            name: fieldName,
            value: percentageString,
            asNumber: { $0.double },
            save: { self.interactor.savePercentage($0 ?? 0, for: ingredient, for: self.breadType) }
        )
    }

    func viewDidChangeQuantity(_ percentage: String?, for ingredient: IngredientType) {
        print("ERROR: Unsupported")
    }


    // MARK: - Did Change Field


    private func didChangeField<T: Numeric>(name: String, value: String?, asNumber: (String)->T?, save: (T?)->Void) {

        // Attempt to convert the given string to a number
        if let value = value?.notEmpty, let number = asNumber(value) {
            // Save the number and update the fields
            save(number)
            self.updateViewForFieldsData(animated: true)
            return
        }

        // If the given string cannot be converted to a number Do not overwrite the saved number

        let title = NSLocalizedString("Not a Number", comment: "")
        let message = NSLocalizedString("The value for \(name) must be a number.", comment: "")

        // Present an alert and reset the number field
        self.router.presentAlert(.init(
            title: title,
            message: message,
            cancelHandler: { [weak self] in
                // Update the fields with the previously saved values
                self?.updateViewForFieldsData(animated: true)
            }
        ))
    }


    // MARK: - BreadType


    private var breadType: BreadType = .default

    private func updateViewForBreadType(animated: Bool) {

        let breadType = self.breadType

        self.view.setBreadType(
            breadType,
            title: breadType.title,
            hideStage2Separator: breadType.hideStage2Separator,
            fieldsData: self.generateFieldsData(),
            animated: animated
        )
    }

    func updateViewForFieldsData(animated: Bool) {
        let fieldsData = self.generateFieldsData()
        self.view.setFieldsData(fieldsData, animated: animated)
    }

    private func generateFieldsData() -> RecipeCalculatorViewData {

        let data = self.interactor.data(for: self.breadType)

        typealias Strings = RecipeCalculatorViewData.IngredientStrings
        let valuesByType = data.ingredientValuesByType

        let stringsByType: [IngredientType: Strings] = valuesByType.mapValuesWithKey{ (ingredient, values) in
            let name = self.breadType.name(for: ingredient)
            let percentageString = values.percentage.formatted
            let quantityString = values.quantity.formatted
            return (name: name, percentage: percentageString, quantity: quantityString)
        }

        return .init(
            loafCount: data.loafCount.formatted,
            loafWeight: data.loafWeight.formatted,
            ingredientStringsByType: stringsByType
        )
    }
}

private extension BreadType {

    static let `default`: BreadType = .wheat

    var title: String {
        switch self {
        case .wheat: return NSLocalizedString("Naturally Leavened Wheat", comment: "")
        case .kamut: return NSLocalizedString("Naturally Leavened Kamut", comment: "")
        case .sourdough: return NSLocalizedString("White Sourdough", comment: "")
        case .bran: return NSLocalizedString("Bran Dough", comment: "")
        }
    }

    var hideStage2Separator: Bool {
        switch self {
        case .wheat, .kamut, .sourdough:
            return false
        case .bran:
            return true
        }
    }

    func name(for ingredient: IngredientType) -> String {

        // Return ingredient name specific for the BreadType
        switch ingredient {
        case .flourPrimary:
            switch self {
            case .wheat: return NSLocalizedString("Sifted Wheat Flour", comment: "")
            case .kamut: return NSLocalizedString("Kamut Flour", comment: "")
            case .sourdough: return NSLocalizedString("White Flour", comment: "")
            case .bran: return NSLocalizedString("Bran Flour", comment: "")
            }

        case .flourSecondary:
            if (self == .sourdough) {
                return NSLocalizedString("Wheat Flour", comment: "")
            }

        case .waterStage1:
            if (self == .bran) {
                return NSLocalizedString("Water", comment: "")
            }

        case .waterStage2, .leaven, .salt:
            break
        }

        return ingredient.defaultName
    }
}

private extension IngredientType {

    var defaultName: String {
        switch self {
        case .flourPrimary: return NSLocalizedString("Flour", comment: "")
        case .flourSecondary: return NSLocalizedString("Flour 2", comment: "")
        case .waterStage1: return NSLocalizedString("Water (Stage 1)", comment: "")
        case .waterStage2: return NSLocalizedString("Water (Stage 2)", comment: "")
        case .leaven: return NSLocalizedString("Leaven", comment: "")
        case .salt: return NSLocalizedString("Salt", comment: "")
        }
    }
}


// MARK: - Number/String conversion


private extension Double {

    var formatted: String {
        if (self < 10) {
            return String(format: "%.2f", self)
        }
        else if (self < 100) {
            return String(format: "%.1f", self)
        }

        return String(format: "%.0f", self)
    }
}

private extension Int {

    var formatted: String {
        return "\(self)"
    }
}

private extension String {

    var double: Double? {
        return Double(self)
    }

    var int: Int? {
        return Int(self)
    }
}


// MARK: - Localized Strings


private struct LocalizedStrings {

    struct Field {
        static let loafCountName = NSLocalizedString("Loaves", comment: "The default name for the 'Loaves' text field")
        static let loafWeightName = NSLocalizedString("Loaf Weight", comment: "The default name for the 'Loaf Weight' text field")
        static let emptyValue = NSLocalizedString("empty", comment: "Represents a text field value that is empty")
    }
}
