//
//  RecipeDetailInteractor.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/9/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


class RecipeDetailInteractor: RecipeDetailInteractorToPresenter {

    init(_ recipe: Recipe) {
        self.recipe = recipe
        self.updateStageMap()
        self.updateIngredientMap()
        self.updateCachedQuantities()
    }


    // MARK: - RecipeDetailInteractorToPresenter


    func saveRecipe() {
        // TODO: Save the recipe
    }

    var recipeTitle: String {
        get { return self.recipe.title }
        set { self.recipe.title = newValue }
    }

    var loafCount: Int {
        get { return self.recipe.loafCount }
        set {
            self.recipe.loafCount = newValue
            self.updateCachedQuantities()
        }
    }

    var quantityPerLoaf: Double {
        get { return self.recipe.quantityPerLoaf }
        set {
            self.recipe.quantityPerLoaf = newValue
            self.updateCachedQuantities()
        }
    }

    private(set) lazy var stages: [RecipeDetail.Stage] = self.generateCachedStages()

    func setStageTitle(_ title: String, id: UUID) {

        if let stage = self.stageById[id] {
            stage.title = title
        }
    }

    func setIngredientName(_ name: String, id: UUID) {

        if let ingredient = self.ingredientById[id] {
            ingredient.name = name
        }
    }

    func setIngredientWeight(_ weight: Double, id: UUID) {

        if let ingredient = self.ingredientById[id] {
            ingredient.weight = weight
            self.updateCachedQuantities()
        }
    }

    func quantityForIngredient(withId id: UUID) -> Double {
        return self.quantityByIngredientId[id]!
    }

    func solveForFlourQuantity(_ flourQuantity: Double) {

        let flourWeight = self.ingredientById.values
            // Filter only ingredients that are flour
            .filter{ $0.isFlour }
            // Add all the weights together
            .reduce(0, { $0 + $1.weight })

        let totalWeight = self.ingredientById.values.reduce(0, { $0 + $1.weight })
        let totalQuantity = flourQuantity * (totalWeight / flourWeight)

        self.loafCount = Int(totalQuantity / self.quantityPerLoaf)
        self.quantityPerLoaf = totalQuantity / Double(self.loafCount)

        self.updateCachedQuantities()
    }


    // MARK: - Recipe


    private let recipe: Recipe


    // MARK: - Cached Stages


    private func updateCachedStages() {
        self.stages = self.generateCachedStages()
    }

    private func generateCachedStages() -> [RecipeDetail.Stage] {
        return self.recipe.stages.map{ $0.detailData }
    }


    // MARK: - Cached Quantities


    private func updateCachedQuantities() {
        self.quantityByIngredientId = self.generateCachedQuantities()
    }

    private lazy var quantityByIngredientId: [UUID: Double] = self.generateCachedQuantities()

    private func generateCachedQuantities() -> [UUID: Double] {

        // Sum the ingredients' weights
        let weightById = self.recipe.stages
            // Combine ingredients from each stage
            .flatMap{ $0.ingredients }
            // Key each ingredient by its id
            .dictionary{ ($0.id, $0.weight) }

        let weightSum = weightById.values.reduce(0, +)

        guard (weightSum > 0) else {
            // If the sum of the weights is zero, each quantity must also be zero
            return weightById.mapValues{ _ in 0 }
        }

        // Calculate the total quantity
        let loafCount = self.recipe.loafCount
        let quantityPerLoaf = self.recipe.quantityPerLoaf
        let totalQuantity = (Double(loafCount) * quantityPerLoaf)

        // Adjust each weight by the sum of all the weights and multiply by the total quantity
        return weightById.mapValues{ ($0 / weightSum) * totalQuantity }
    }


    // MARK: - Mapped Data


    private var stageById: [UUID: Recipe.Stage] = [:]
    private var ingredientById: [UUID: Recipe.Ingredient] = [:]

    private func updateStageMap() {
        self.stageById = self.recipe.stages.dictionary(key: { $0.id })
    }

    private func updateIngredientMap() {
        self.ingredientById = self.recipe.stages.reduce(into: [:], { (result, stage) in
            stage.ingredients.forEach { result[$0.id] = $0 }
        })
    }
}


private extension Recipe.Stage {

    var detailData: RecipeDetail.Stage {
        return (self.id, self.title, self.ingredients.map{ $0.detailData })
    }
}

private extension Recipe.Ingredient {

    var detailData: RecipeDetail.Ingredient {
        return (self.id, self.name, self.weight)
    }
}
