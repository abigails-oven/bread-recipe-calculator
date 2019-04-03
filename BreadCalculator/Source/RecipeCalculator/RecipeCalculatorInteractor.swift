//
//  RecipeCalculatorInteractor.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/26/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation

class RecipeCalculatorInteractor: RecipeCalculatorInteractorToPresenter {

    // MARK: - RecipeCalculatorInteractorToPresenter


    func data(for breadType: BreadType) -> RecipeCalculatorData {

        let data = self.savedData(for: breadType)
        let quantityByIngredient = self.quantityByIngredient(for: breadType)
        let valuesByType = self.valuesByType(for: breadType, percentages: data.percentageByIngredient, quanitites: quantityByIngredient)

        return .init(
            loafCount: data.loafCount,
            loafWeight: data.loafWeight,
            ingredientValuesByType: valuesByType
        )
    }

    func saveLoafCount(_ loafCount: Int, for breadType: BreadType) {
        self.savedData(for: breadType).loafCount = loafCount
        self.updateQuantities(for: breadType)
    }

    func saveLoafWeight(_ loafWeight: Double, for breadType: BreadType) {
        self.savedData(for: breadType).loafWeight = loafWeight
        self.updateQuantities(for: breadType)
    }

    func savePercentage(_ percentage: Percentage, for ingredient: IngredientType, for breadType: BreadType) {
        self.savedData(for: breadType).percentageByIngredient[ingredient] = percentage
        self.updateQuantities(for: breadType)
    }


    // MARK: - Calculate by Flour Weight


    private func calculateBy(flourWeight: Double, loafCount: Int, percentByIngredient: [IngredientType: Percentage]) -> (loafWeight: Double, quantityByIngredient: [IngredientType: Quantity]) {

        var flourPercentage = percentByIngredient[.flourPrimary]!

        if let flourSecondaryPercentage = percentByIngredient[.flourSecondary] {
            flourPercentage = flourSecondaryPercentage
        }

        let multiplier = flourWeight / flourPercentage

        // Calculate the quantity of each ingredient by multiplying its percentage by the flour quantity
        let quantityByIngredient = percentByIngredient.mapValues{ ($0 * multiplier) }

        // Loaf weight == Sum of all quantities divided by the loaf count
        let loafWeight = quantityByIngredient.values.reduce(0, +) / Double(loafCount)

        return (loafWeight, quantityByIngredient)
    }


    // MARK: - Public Data


    private func valuesByType(for breadType: BreadType, percentages: [IngredientType: Percentage], quanitites: [IngredientType: Quantity]) -> [IngredientType: RecipeCalculatorData.IngredientValues] {
        return breadType.ingredients.dictionary(value: { ingredient in
            let percentage = percentages[ingredient]!
            let quantity = quanitites[ingredient]!
            return (percentage: percentage, quantity: quantity)
        })
    }


    // MARK: - Quantities


    private func quantityByIngredient(for breadType: BreadType) -> [IngredientType: Quantity] {

        if let quantityByIngredient = self.quantityByIngredientByBread[breadType] {
            return quantityByIngredient
        }

        // Calculate and save ingredient quantities
        let quantityByIngredient = self.calculateQuantities(for: breadType)
        self.quantityByIngredientByBread[breadType] = quantityByIngredient

        return quantityByIngredient
    }

    private var quantityByIngredientByBread: [BreadType: [IngredientType: Quantity]] = [:]


    // MARK: - Calculate Quantities


    private func updateQuantities(for breadType: BreadType) {
        self.quantityByIngredientByBread[breadType] = self.calculateQuantities(for: breadType)
    }

    private func calculateQuantities(for breadType: BreadType) -> [IngredientType: Quantity] {

        let data = self.savedData(for: breadType)
        let loafCount = data.loafCount
        let loafWeight = data.loafWeight
        let percentages = data.percentageByIngredient

        // Sum the ingredients' percentages
        let percentageSum = percentages.values.reduce(0, +)

        guard (percentageSum > 0) else {
            // If the sum of the percentages is zero, each quantity must also be zero
            return percentages.mapValues{ _ in 0 }
        }

        // Total weight == Weight of the loaves divided by the sum of the ingredients' percentages
        let totalWeight = (Double(loafCount) * loafWeight) / percentageSum

        // Quantity per ingredient == ingredient's percentage multiplied by the total weight
        return percentages.mapValues{ $0 * totalWeight }
    }


    // MARK: - Saved Data


    private func savedData(for breadType: BreadType) -> SavedRecipeCalculatorData {
        return self.savedDataByBreadType[breadType] ?? self.defaultDataByBreadType[breadType]!
    }

    private var savedDataByBreadType: [BreadType: SavedRecipeCalculatorData] = [:]

    private class SavedRecipeCalculatorData {
        var loafCount: Int
        var loafWeight: Double
        var percentageByIngredient: [IngredientType: Percentage]

        init(loafCount: Int, loafWeight: Double, percentageByIngredient: [IngredientType: Percentage]) {
            self.loafCount = loafCount
            self.loafWeight = loafWeight
            self.percentageByIngredient = percentageByIngredient
        }
    }


    // MARK: - Defaults


    private let defaultDataByBreadType: [BreadType: SavedRecipeCalculatorData] = {

        return BreadType.all.dictionary(value: { breadType in

            let percentages: [IngredientType: Percentage]

            switch breadType {
            case .wheat: percentages = [
                .flourPrimary: 100,
                .waterStage1: 70,
                .leaven: 20,
                .waterStage2: 5,
                .salt: 2.6
                ]
            case .kamut: percentages = [
                .flourPrimary: 100,
                .waterStage1: 63,
                .leaven: 20,
                .waterStage2: 5,
                .salt: 2.6
                ]
            case .sourdough: percentages = [
                .flourPrimary: 90,
                .flourSecondary: 10,
                .waterStage1: 60,
                .leaven: 20,
                .waterStage2: 5,
                .salt: 2.6
                ]
            case .bran: percentages = [
                .flourPrimary: 100,
                .waterStage1: 100,
                .leaven: 20,
                .salt: 2.6
                ]
            }

            // Assert each ingredient is represented for the bread type
            assert(Set(percentages.keys) == breadType.ingredients)

            return .init(
                loafCount: 2,
                loafWeight: 2,
                percentageByIngredient: percentages
            )
        })
    }()
}


// MARK: - BreadType.ingredients


private extension BreadType {

    var ingredients: Set<IngredientType> {
        switch self {
        case .wheat: return [.flourPrimary, .waterStage1, .waterStage2, .leaven, .salt]
        case .kamut: return [.flourPrimary, .waterStage1, .waterStage2, .leaven, .salt]
        case .sourdough: return [.flourPrimary, .flourSecondary, .waterStage1, .waterStage2, .leaven, .salt]
        case .bran: return [.flourPrimary, .waterStage1, .leaven, .salt]
        }
    }
}
