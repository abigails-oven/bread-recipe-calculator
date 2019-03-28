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

    func hideFlourSecondary(_ shouldHide: Bool, animated: Bool)
    func hideWaterStage2(_ shouldHide: Bool, animated: Bool)
    func hideStage2Separator(_ shouldHide: Bool, animated: Bool)

    func setTitle(_ title: String, animated: Bool)
    func setFlourPrimaryName(_ name: String, animated: Bool)
    func setFlourSecondaryName(_ name: String, animated: Bool)
    func setWaterStage1Name(_ name: String, animated: Bool)

    func setLoafCount(_ string: String)
    func setLoafWeight(_ string: String)
    func setQuantities(_ quantityByIngredient: [IngredientType: String?])
    func setPercentages(_ percentageByIngredient: [IngredientType: String?])

    var loafCount: String? { get }
    var loafWeight: String? { get }
    func quantity(for ingredient: IngredientType) -> String?
    func percentage(for ingredient: IngredientType) -> String?

    func setBreadType(_ breadType: BreadType)
}


// MARK: - Presenter


protocol RecipeCalculatorPresenterToView: class {

    func viewDidLoad()
    func viewDidChangeFieldValue()
    func viewDidChangeBreadType(_ breadType: BreadType)
}


// MARK: - Interactor


protocol RecipeCalculatorInteractorToPresenter: class {

    func calculateBy(flourWeight: Double, loafCount: Int, percentByIngredient: [IngredientType: Percentage]) -> (loafWeight: Double, quantityByIngredient: [IngredientType: Quantity])
    func calculateBy(loafCount: Int, loafWeight: Double, percentByIngredient: [IngredientType: Percentage]) -> [IngredientType: Quantity]
}


// MARK: - Data Types


typealias Percentage = Double
typealias Quantity = Double

enum BreadType: Int {
    case wheat
    case kamut
    case sourdough
    case bran
}

enum IngredientType: Int {
    case flourPrimary
    case flourSecondary
    case waterStage1
    case waterStage2
    case leaven
    case salt
}
