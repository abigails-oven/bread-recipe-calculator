//
//  RecipeCalculatorModuleApi.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


// MARK: - View


protocol RecipeCalculatorViewToPresenter: class {
    func endEditingField()
    func setBreadType(_ breadType: BreadType, title: String, hideStage2Separator: Bool, fieldsData: RecipeCalculatorViewData, animated: Bool)
    func setFieldsData(_ fieldData: RecipeCalculatorViewData, animated: Bool)
}

struct RecipeCalculatorViewData {
    let loafCount: String
    let loafWeight: String
    let ingredientStringsByType: [IngredientType: IngredientStrings]
    typealias IngredientStrings = (name: String, percentage: String, quantity: String)
}


// MARK: - Presenter


protocol RecipeCalculatorPresenterToView: class {
    func viewDidLoad()
    func viewDidChangeBreadType(_ breadType: BreadType)
    func viewDidChangeLoafCount(_ loafCount: String?)
    func viewDidChangeLoafWeight(_ loafWeight: String?)
    func viewDidChangePercentage(_ percentage: String?, for ingredient: IngredientType)
    func viewDidChangeQuantity(_ percentage: String?, for ingredient: IngredientType)
}


// MARK: - Interactor


protocol RecipeCalculatorInteractorToPresenter: class {
    func data(for breadType: BreadType) -> RecipeCalculatorData
    func saveLoafCount(_ loafCount: Int, for breadType: BreadType)
    func saveLoafWeight(_ loafWeight: Double, for breadType: BreadType)
    func savePercentage(_ percentage: Percentage, for ingredient: IngredientType, for breadType: BreadType)
}

struct RecipeCalculatorData {
    let loafCount: Int
    let loafWeight: Double
    let ingredientValuesByType: [IngredientType: IngredientValues]
    typealias IngredientValues = (percentage: Percentage, quantity: Quantity)
}


// MARK: - Data Types


enum BreadType: Int {
    case wheat
    case kamut
    case sourdough
    case bran

    static let all: [BreadType] = BreadType.generateAllSequentialCases()
}

typealias Percentage = Double
typealias Quantity = Double

enum IngredientType: Int {
    case flourPrimary
    case flourSecondary
    case waterStage1
    case waterStage2
    case leaven
    case salt

    static let all: [IngredientType] = IngredientType.generateAllSequentialCases()
}
