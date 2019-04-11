//
//  MockRecipeDetailInteractor.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

@testable import BreadCalculator
import Foundation

class MockRecipeDetailInteractor: RecipeDetailInteractorToPresenter {

    // MARK: - RecipeDetailInteractorToPresenter


    func saveRecipe() {
        self.mock.callCounts.saveRecipe += 1
    }

    var recipeTitle: String {
        get { return self.mock.values.recipeTitle }
        set {
            self.mock.callCounts.setRecipeTitle += 1
            self.mock.values.recipeTitle = newValue
        }
    }

    var loafCount: Int {
        get { return self.mock.values.loafCount }
        set {
            self.mock.callCounts.setLoafCount += 1
            self.mock.values.loafCount = newValue
        }
    }

    var quantityPerLoaf: Double {
        get { return self.mock.values.quantityPerLoaf }
        set {
            self.mock.callCounts.setQuantityPerLoaf += 1
            self.mock.values.quantityPerLoaf = newValue
        }
    }

    var stages: [RecipeDetail.Stage] {
        return self.mock.values.stages
    }

    func setStageTitle(_ title: String, id: UUID) {
        self.mock.callCounts.setStageTitle += 1
        self.mock.values.stageTitle = title
    }

    func setIngredientName(_ name: String, id: UUID) {
        self.mock.callCounts.setIngredientName += 1
        self.mock.values.ingredientName = name
    }

    func setIngredientWeight(_ weight: Double, id: UUID) {
        self.mock.callCounts.setIngredientWeight += 1
        self.mock.values.ingredientWeight = weight
    }

    func quantityForIngredient(withId id: UUID) -> Double {
        return self.mock.values.quantityForIngredient
    }

    func solveForFlourQuantity(_ flourQuantity: Double) {
        self.mock.callCounts.solveForFlourQuantity += 1
        self.mock.values.flourQuantity = flourQuantity
    }


    // MARK: - Public Accessors


    var mock: Mock = .init()

    struct Mock {

        var callCounts: Counts = .init()
        var values: Values = .init()

        struct Counts {
            var saveRecipe: Int = 0
            var setRecipeTitle: Int = 0
            var setLoafCount: Int = 0
            var setQuantityPerLoaf: Int = 0
            var setStageTitle: Int = 0
            var setIngredientName: Int = 0
            var setIngredientWeight: Int = 0
            var solveForFlourQuantity: Int = 0
        }

        struct Values {
            var recipeTitle: String = ""
            var loafCount: Int = 0
            var quantityPerLoaf: Double = 0
            var stages: [RecipeDetail.Stage] = []
            var stageTitle: String = ""
            var ingredientName: String = ""
            var ingredientWeight: Double = 0
            var quantityForIngredient: Double = 0
            var flourQuantity: Double = 0
        }
    }
}
