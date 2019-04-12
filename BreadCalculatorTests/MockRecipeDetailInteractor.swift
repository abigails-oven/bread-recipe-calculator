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
        get { return self.mock.output.recipeTitle }
        set {
            self.mock.callCounts.setRecipeTitle += 1
            self.mock.input.recipeTitle = newValue
        }
    }

    var loafCount: Int {
        get { return self.mock.output.loafCount }
        set {
            self.mock.callCounts.setLoafCount += 1
            self.mock.input.loafCount = newValue
        }
    }

    var quantityPerLoaf: Double {
        get { return self.mock.output.quantityPerLoaf }
        set {
            self.mock.callCounts.setQuantityPerLoaf += 1
            self.mock.input.quantityPerLoaf = newValue
        }
    }

    var stages: [RecipeDetail.Stage] {
        return self.mock.output.stages
    }

    func setStageTitle(_ title: String, id: UUID) {
        self.mock.callCounts.setStageTitle += 1
        self.mock.input.stageTitle = title
    }

    func setIngredientName(_ name: String, id: UUID) {
        self.mock.callCounts.setIngredientName += 1
        self.mock.input.ingredientName = name
    }

    func setIngredientWeight(_ weight: Double, id: UUID) {
        self.mock.callCounts.setIngredientWeight += 1
        self.mock.input.ingredientWeight = weight
    }

    func quantityForIngredient(withId id: UUID) -> Double {
        return self.mock.output.quantityForIngredient
    }

    func solveForFlourQuantity(_ flourQuantity: Double) {
        self.mock.callCounts.solveForFlourQuantity += 1
        self.mock.input.flourQuantity = flourQuantity
    }


    // MARK: - Public Accessors


    var mock: Mock = .init()

    struct Mock {

        var callCounts: Counts = .init()
        var input: Input = .init()
        var output: Output = .init()

        mutating func clearCallCounts() {
            self.callCounts = .init()
        }

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

        struct Input {
            var recipeTitle: String = ""
            var loafCount: Int = 0
            var quantityPerLoaf: Double = 0
            var stageTitle: String = ""
            var ingredientName: String = ""
            var ingredientWeight: Double = 0
            var flourQuantity: Double = 0
        }

        struct Output {
            var recipeTitle: String = ""
            var loafCount: Int = 0
            var quantityPerLoaf: Double = 0
            var stages: [RecipeDetail.Stage] = []
            var quantityForIngredient: Double = 0
        }
    }
}
