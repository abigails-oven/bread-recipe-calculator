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


    func calculateBy(flourWeight: Double, loafCount: Int, percentByIngredient: [IngredientType: Percentage]) -> (loafWeight: Double, quantityByIngredient: [IngredientType: Quantity]) {

        // Record the call parameters
        self.callsToCalculateByFlour.append((flourWeight: flourWeight, loafCount: loafCount, percentByIngredient: percentByIngredient))

        // Use this class's methods to calculate the return values
        let loafWeight = self.calcLoafWeightForFlour(flourWeight: flourWeight, loafCount: loafCount)
        let quantityByIngredient = percentByIngredient.mapValuesWithKey{ (ingredient, percentage) -> Double in
            self.calcQuantityForFlour(flourWeight: flourWeight, loafCount: loafCount, ingredient: ingredient, percentage: percentage)
        }

        return (loafWeight, quantityByIngredient)
    }

    func calculateBy(loafCount: Int, loafWeight: Double, percentByIngredient: [IngredientType: Percentage]) -> [IngredientType: Quantity] {

        // Record the call parameters
        self.callsToCalculateByLoaves.append((loafCount: loafCount, loafWeight: loafWeight, percentByIngredient: percentByIngredient))

        // Use this class's methods to calculate a return value
        return percentByIngredient.mapValuesWithKey{ (ingredient, percentage) -> Double in
            self.calcQuantityForLoaves(loafCount: loafCount, loafWeight: loafWeight, ingredient: ingredient, percentage: percentage)
        }
    }


    // MARK: - Insights


    typealias CalcByFlourParameters = (flourWeight: Double, loafCount: Int, percentByIngredient: [IngredientType: Percentage])
    typealias CalcByLoavesParameters = (loafCount: Int, loafWeight: Double, percentByIngredient: [IngredientType: Percentage])

    private(set) var callsToCalculateByFlour: [CalcByFlourParameters] = []
    private(set) var callsToCalculateByLoaves: [CalcByLoavesParameters] = []


    // MARK: - Subclassable methods


    func calcLoafWeightForFlour(flourWeight: Double, loafCount: Int) -> Double {
        return 10
    }

    func calcQuantityForFlour(flourWeight: Double, loafCount: Int, ingredient: IngredientType, percentage: Double) -> Double {
        return 10
    }

    func calcQuantityForLoaves(loafCount: Int, loafWeight: Double, ingredient: IngredientType, percentage: Double) -> Double {
        return 10
    }
}
