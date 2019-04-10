//
//  RecipeDetailPresenter.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


class RecipeDetailPresenter: RecipeDetailPresenterToView {

    // MARK: - Init


    init(_ view: RecipeDetailViewToPresenter, _ interactor: RecipeDetailInteractorToPresenter, _ router: RecipeDetailRouterToPresenter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }


    // MARK: - Module Accessors


    private weak var view: RecipeDetailViewToPresenter!
    private let interactor: RecipeDetailInteractorToPresenter
    private let router: RecipeDetailRouterToPresenter


    // MARK: - RecipeDetailPresenterToView


    func viewDidLoad() {
        self.updateViewEditingAppearance()
        self.view.setTitle(self.interactor.recipeTitle)
        // TODO: Format properly
        self.view.setLoafCount("\(self.interactor.loafCount)")
        self.view.setQuantityPerLoaf("\(self.interactor.quantityPerLoaf)")
    }

    func userDidTapBackButton() {
        self.router.dismiss()
    }

    func userDidTapEditButton() {
        // Toggle edit mode
        self.isEditing = !self.isEditing
        self.updateViewEditingAppearance()
    }

    func userDidTapSolveForFlourButton() {

        self.router.promptForFlourQuantity(title: self.localized.flourPrompt.title) { flourQuantityString in

            // TODO: Strip formatting properly
            guard let flourQuantityString = flourQuantityString?.notEmpty, let flourQuantity = Double(flourQuantityString) else {
                return
            }

            // TODO: Format properly
            self.interactor.solveForFlourQuantity(flourQuantity)
            self.view.setLoafCount("\(self.interactor.loafCount)")
            self.view.setQuantityPerLoaf("\(self.interactor.quantityPerLoaf)")
            self.updateViewQuantities()
        }
    }

    func userDidChangeLoafCount(_ loafCountString: String?) {

        // TODO: Strip formatting properly
        guard let loafCountString = loafCountString?.notEmpty, let loafCount = Int(loafCountString) else {
            // TODO: Show alert and reset
            return
        }

        self.interactor.loafCount = loafCount
        self.updateViewQuantities()
    }

    func userDidChangeQuantityPerLoaf(_ quantityPerLoafString: String?) {

        // TODO: Strip formatting properly
        guard let quantityPerLoafString = quantityPerLoafString?.notEmpty, let quantityPerLoaf = Double(quantityPerLoafString) else {
            // TODO: Show alert and reset
            return
        }

        self.interactor.quantityPerLoaf = quantityPerLoaf
        self.updateViewQuantities()
    }

    func userDidChangeStageTitle(_ title: String?, at index: Int) {

        guard let title = title?.notEmpty else {
            // TODO: Show alert and reset
            return
        }

        let stage = self.stage(at: index)
        self.interactor.setStageTitle(title, id: stage.id)
    }

    func userDidChangeName(_ name: String?, at indexPath: IndexPath) {

        guard let name = name?.notEmpty else {
            // TODO: Show alert and reset
            return
        }

        let ingredient = self.ingredient(at: indexPath)
        self.interactor.setIngredientName(name, id: ingredient.id)
    }

    func userDidChangeWeight(_ weightString: String?, at indexPath: IndexPath) {

        guard let weightString = weightString?.notEmpty, let weight = Double(weightString) else {
            // TODO: Show alert and reset
            return
        }

        let ingredient = self.ingredient(at: indexPath)
        self.interactor.setIngredientWeight(weight, id: ingredient.id)
        self.updateViewQuantities()
    }

    var numberOfStages: Int {
        return self.interactor.stages.count
    }

    func numberOfIngredients(forStage stageIndex: Int) -> Int {
        return self.stage(at: stageIndex).ingredients.count
    }

    func configure(_ header: RecipeDetailStageHeaderProtocol, at index: Int) {
        let stage = self.stage(at: index)
        header.setTitle(stage.title)
        header.setIsEditing(self.isEditing)
    }

    func configure(_ cell: RecipeDetailIngredientCellProtocol, at indexPath: IndexPath) {
        let ingredient = self.ingredient(at: indexPath)
        let quantity = self.interactor.quantityForIngredient(withId: ingredient.id)
        cell.setName(ingredient.name)
        // TODO: Format properly
        cell.setWeight("\(ingredient.weight)")
        cell.setQuantity("\(quantity)")
        cell.setIsEditing(self.isEditing)
    }

    func canEditCell(at indexPath: IndexPath) -> Bool {
        return true
    }


    // MARK: - Editing


    private var isEditing: Bool = false


    // MARK: - Update View


    private func updateViewEditingAppearance() {

        // Set button title
        let strings = self.localized.editButton
        let title = self.isEditing ? strings.done : strings.edit
        self.view.setEditButtonTitle(title)

        self.view.setIsEditing(self.isEditing)
    }

    private func updateViewQuantities() {

        var quantityByIndexPath: [IndexPath: String] = [:]

        // Map each quantity to an index path for the view
        for (stageIndex, stage) in self.interactor.stages.enumerated() {
            for (ingredientIndex, ingredient) in stage.ingredients.enumerated() {
                let indexPath = IndexPath(row: ingredientIndex, section: stageIndex)
                let quantity = self.interactor.quantityForIngredient(withId: ingredient.id)
                // TODO: Format quantity properly
                quantityByIndexPath[indexPath] = "\(quantity)"
            }
        }

        self.view.setQuantities(quantityByIndexPath)
    }


    // MARK: - Convenience Accessors


    private func stage(at index: Int) -> RecipeDetail.Stage {
        return self.interactor.stages[index]
    }

    private func ingredient(at indexPath: IndexPath) -> RecipeDetail.Ingredient {
        let stage = self.stage(at: indexPath.section)
        return stage.ingredients[indexPath.row]
    }


    // MARK: - Localized Strings


    private let localized = LocalizedStrings()

    private struct LocalizedStrings {
        let flourPrompt = FlourPrompt()
        let editButton = EditButton()

        struct FlourPrompt {
            let title = NSLocalizedString("Total Flour Quantity", comment: "")
        }

        struct EditButton {
            let edit = NSLocalizedString("Edit", comment: "")
            let done = NSLocalizedString("Done", comment: "")
        }
    }
}
