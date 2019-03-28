//
//  MockRecipeCalculatorView.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

@testable import BreadCalculator
import Foundation


class MockRecipeCalculatorView: RecipeCalculatorViewToPresenter {

    typealias SetHiddenParams = (shouldHide: Bool, animated: Bool)
    typealias SetStringParams = (string: String, animated: Bool)

    private(set) var callsToHideFlourSecondary: [SetHiddenParams] = []
    private(set) var callsToHideWaterStage2: [SetHiddenParams] = []
    private(set) var callsToHideStage2Separator: [SetHiddenParams] = []
    private(set) var callsToSetTitle: [SetStringParams] = []
    private(set) var callsToSetFlourPrimaryName: [SetStringParams] = []
    private(set) var callsToSetFlourSecondaryName: [SetStringParams] = []
    private(set) var callsToSetWaterStage1Name: [SetStringParams] = []
    private(set) var callsToSetLoafCount: [String] = []
    private(set) var callsToSetLoafWeight: [String] = []
    private(set) var callsToSetQuantities: [[IngredientType: String?]] = []
    private(set) var callsToSetPercentages: [[IngredientType: String?]] = []
    private(set) var callsToSetBreadType: [BreadType] = []


    // MARK: - RecipeCalculatorViewToPresenter


    func hideFlourSecondary(_ shouldHide: Bool, animated: Bool) {
        self.callsToHideFlourSecondary.append((shouldHide: shouldHide, animated: animated))
    }

    func hideWaterStage2(_ shouldHide: Bool, animated: Bool) {
        self.callsToHideWaterStage2.append((shouldHide: shouldHide, animated: animated))
    }

    func hideStage2Separator(_ shouldHide: Bool, animated: Bool) {
        self.callsToHideStage2Separator.append((shouldHide: shouldHide, animated: animated))
    }

    func setTitle(_ title: String, animated: Bool) {
        self.callsToSetTitle.append((title, animated))
    }

    func setFlourPrimaryName(_ name: String, animated: Bool) {
        self.callsToSetFlourPrimaryName.append((name, animated))
    }

    func setFlourSecondaryName(_ name: String, animated: Bool) {
        self.callsToSetFlourSecondaryName.append((name, animated))
    }

    func setWaterStage1Name(_ name: String, animated: Bool) {
        self.callsToSetWaterStage1Name.append((name, animated))
    }

    func setLoafCount(_ string: String) {
        self.loafCount = string
        self.callsToSetLoafCount.append(string)
    }

    func setLoafWeight(_ string: String) {
        self.loafWeight = string
        self.callsToSetLoafWeight.append(string)
    }

    func setQuantities(_ quantityByIngredient: [IngredientType : String?]) {
        self.callsToSetQuantities.append(quantityByIngredient)
    }

    func setPercentages(_ percentageByIngredient: [IngredientType : String?]) {
        self.callsToSetPercentages.append(percentageByIngredient)
    }

    private(set) var loafCount: String?

    private(set) var loafWeight: String?

    func quantity(for ingredient: IngredientType) -> String? {
        return self.callsToSetQuantities.last?[ingredient] ?? nil
    }

    func percentage(for ingredient: IngredientType) -> String? {
        return self.callsToSetPercentages.last?[ingredient] ?? nil
    }

    func setBreadType(_ breadType: BreadType) {
        self.callsToSetBreadType.append(breadType)
    }
}
