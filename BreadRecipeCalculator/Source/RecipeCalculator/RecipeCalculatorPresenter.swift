//
//  RecipeCalculatorPresenter.swift
//  BreadRecipeCalculator
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation

class RecipeCalculatorPresenter: RecipeCalculatorPresenterToView {

    // MARK: - Init


    init(_ view: RecipeCalculatorViewToPresenter, _ interactor: RecipeCalculatorInteractorToPresenter) {
        self.view = view
        self.interactor = interactor
    }

    private weak var view: RecipeCalculatorViewToPresenter!
    private let interactor: RecipeCalculatorInteractorToPresenter


    // MARK: - RecipeCalculatorPresenterToView


    func viewDidLoad() {
        self.view.setBreadType(self.breadType)
        self.updateViewForBreadType(animated: false)
        self.updateViewForLoafCountAndWeight()
    }

    func viewDidChangeFieldValue() {
        self.updateViewForLoafCountAndWeight()
    }

    func viewDidChangeBreadType(_ breadType: BreadType) {

        self.breadType = breadType
        self.updateViewForBreadType(animated: true)
    }


    // MARK: - BreadType


    private var breadType: BreadType = .default

    private func updateViewForBreadType(animated: Bool) {

        self.view.setTitle(self.breadType.title, animated: animated)

        self.view.setFlourPrimaryName(self.breadType.nameForFlourPrimary, animated: animated)
        self.view.setFlourSecondaryName(self.breadType.nameForFlourSecondary, animated: animated)
        self.view.setWaterStage1Name(self.breadType.nameForWaterStage1, animated: animated)

        self.view.hideFlourSecondary(self.breadType.hideFlourSecondary, animated: animated)
        self.view.hideStage2Separator(self.breadType.hideStage2Separator, animated: animated)
        self.view.hideWaterStage2(self.breadType.hideWaterStage2, animated: animated)
    }


    // MARK: - Loaf Count/Weight


    private func updateViewForLoafCountAndWeight() {

        let ingredients = self.breadType.ingredients

        let percentByIngredient = ingredients.dictionary{ ingredient -> (IngredientType, Double) in
            let string = self.view.percentage(for: ingredient)
            let percentage = string?.double ?? 0
            return (ingredient, percentage)
        }

        let loafCount = self.view.loafCount?.int ?? 0
        let loafWeight = self.view.loafWeight?.double ?? 0

        let quantityByIngredient = self.interactor.quantityByIngredient(
            loafCount: loafCount,
            loafWeight: loafWeight,
            percentByIngredient: percentByIngredient
        )

        let quantityStringByIngredient = quantityByIngredient.mapValues{ String(format: "%.2f", $0) }

        self.view.setQuantities(quantityStringByIngredient)
    }
}

private extension BreadType {

    static let `default`: BreadType = .wheat

    var ingredients: Set<IngredientType> {
        switch self {
        case .wheat: return [.flourPrimary, .waterStage1, .waterStage2, .leaven, .salt]
        case .kamut: return [.flourPrimary, .waterStage1, .waterStage2, .leaven, .salt]
        case .sourdough: return [.flourPrimary, .flourSecondary, .waterStage1, .waterStage2, .leaven, .salt]
        case .bran: return [.flourPrimary, .waterStage1, .leaven, .salt]
        }
    }

    var title: String {
        switch self {
        case .wheat: return NSLocalizedString("Naturally Leavened Wheat", comment: "")
        case .kamut: return NSLocalizedString("Naturally Leavened Kamut", comment: "")
        case .sourdough: return NSLocalizedString("White Sourdough", comment: "")
        case .bran: return NSLocalizedString("Bran Dough", comment: "")
        }
    }

    var nameForFlourPrimary: String {
        switch self {
        case .wheat: return NSLocalizedString("Sifted Wheat Flour", comment: "")
        case .kamut: return NSLocalizedString("Kamut Flour", comment: "")
        case .sourdough: return NSLocalizedString("Wheat Flour", comment: "")
        case .bran: return NSLocalizedString("Bran Flour", comment: "")
        }
    }

    var nameForFlourSecondary: String {
        switch self {
        case .wheat, .kamut, .bran:
            return ""
        case .sourdough:
            return NSLocalizedString("White Flour", comment: "")
        }
    }

    var nameForWaterStage1: String {
        switch self {
        case .wheat, .kamut, .sourdough:
            return NSLocalizedString("Water (Stage 1)", comment: "")
        case .bran:
            return NSLocalizedString("Water", comment: "")
        }
    }

    var hideFlourSecondary: Bool {
        switch self {
        case .wheat, .kamut, .bran:
            return true
        case .sourdough:
            return false
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

    var hideWaterStage2: Bool {
        switch self {
        case .wheat, .kamut, .sourdough:
            return false
        case .bran:
            return true
        }
    }
}


// MARK: - Number to string conversion


private extension String {

    var double: Double? {
        return Double(self)
    }

    var int: Int? {
        return Int(self)
    }
}


// MARK: - Defaults


private let DEFAULT_LOAF_COUNT: Int = 2
private let DEFAULT_LOAF_WEIGHT: Double = 2
