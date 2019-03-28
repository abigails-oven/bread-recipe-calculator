//
//  RecipeCalculatorInteractor.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/26/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation

class RecipeCalculatorInteractor: RecipeCalculatorInteractorToPresenter {

    func calculateBy(flourWeight: Double, loafCount: Int, percentByIngredient: [IngredientType: Percentage]) -> (loafWeight: Double, quantityByIngredient: [IngredientType: Quantity]) {

        let flourQuantity = flourWeight / 100

        // Calculate the quantity of each ingredient by multiplying its percentage by the flour quantity
        let quantityByIngredient = percentByIngredient.mapValuesWithKey{ (ingredient, percent) -> Double in

            switch ingredient {
            case .flourPrimary:
                return flourQuantity
            case .flourSecondary, .waterStage1, .waterStage2, .leaven, .salt:
                return (percent * flourQuantity)
            }
        }

        // Loaf weight == Sum of all quantities divided by the loaf count
        let loafWeight = quantityByIngredient.values.reduce(0, +) / Double(loafCount)

        return (loafWeight, quantityByIngredient)
    }

    func calculateBy(loafCount: Int, loafWeight: Double, percentByIngredient: [IngredientType: Percentage]) -> [IngredientType: Quantity] {
        // Sum the ingredients' percentages
        let percentSum = percentByIngredient.values.reduce(0, +)
        // Total weight == Weight of the loaves divided by the sum of the ingredients' percentages
        let totalWeight = (Double(loafCount) * loafWeight) / percentSum
        // Quantity per ingredient == ingredient's percentage multiplied by the total weight
        return percentByIngredient.mapValues{ $0 * totalWeight }
    }
}
