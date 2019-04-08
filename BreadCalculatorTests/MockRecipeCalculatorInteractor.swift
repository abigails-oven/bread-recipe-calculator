//
//  MockRecipeCalculatorInteractor.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

@testable import BreadCalculator
import Foundation

class MockRecipeCalculatorInteractor: RecipeCalculatorInteractorToPresenter {

    // MARK: - RecipeCalculatorInteractorToPresenter


    func data(for breadType: BreadType) -> RecipeCalculatorData {
        self.calls.data.append(breadType)
        return .init(
            loafCount: 0,
            loafWeight: 0,
            ingredientValuesByType: [:]
        )
    }

    func saveLoafCount(_ loafCount: Int, for breadType: BreadType) {
        self.calls.saveLoafCount.append((loafCount, breadType))
    }

    func saveLoafWeight(_ loafWeight: Double, for breadType: BreadType) {
        self.calls.saveLoafWeight.append((loafWeight, breadType))
    }

    func savePercentage(_ percentage: Percentage, for ingredient: IngredientType, for breadType: BreadType) {
        self.calls.savePercentage.append((percentage, ingredient, breadType))
    }


    // MARK: - Mock Function Calls


    private(set) var calls: Calls = .init()

    struct Calls {
        typealias SaveLoafCount = (loafCount: Int, breadType: BreadType)
        typealias SaveLoafWeight = (loafWeight: Double, breadType: BreadType)
        typealias SavePercentage = (percentage: Percentage, ingredient: IngredientType, breadType: BreadType)

        var data: [BreadType] = []
        var saveLoafCount: [SaveLoafCount] = []
        var saveLoafWeight: [SaveLoafWeight] = []
        var savePercentage: [SavePercentage] = []
    }
}
