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
        self.updateViewLoafCount()
        self.updateViewQuantityPerLoaf()
    }

    func userDidTapEditButton() {
        // Toggle edit mode
        self.isEditing = !self.isEditing
        self.updateViewEditingAppearance()
    }

    func userDidTapSolveForFlourButton() {

        self.router.promptForFlourQuantity(title: self.localized.flourPrompt.title) { flourQuantityString in

            guard let flourQuantityString = flourQuantityString?.notEmpty, let flourQuantity = self.stripToDouble(flourQuantityString) else {
                // TODO: Show alert
                return
            }

            self.interactor.solveForFlourQuantity(flourQuantity)
            self.updateViewLoafCount()
            self.updateViewQuantityPerLoaf()
            self.updateViewQuantities()
        }
    }

    func userDidChangeLoafCount(_ loafCountString: String?) {

        guard let loafCountString = loafCountString?.notEmpty, let loafCount = self.stripToInt(loafCountString) else {
            // TODO: Show alert and reset
            return
        }

        self.interactor.loafCount = loafCount
        self.updateViewQuantities()
    }

    func userDidChangeQuantityPerLoaf(_ quantityPerLoafString: String?) {

        guard let quantityPerLoafString = quantityPerLoafString?.notEmpty, let quantityPerLoaf = self.stripToDouble(quantityPerLoafString) else {
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
        cell.setWeight(self.format(ingredient.weight))
        cell.setQuantity(self.format(quantity))
        cell.setIsEditing(self.isEditing)
    }

    func canEditCell(at indexPath: IndexPath) -> Bool {
        return true
    }

/*
    private func didChangeField<T: Numeric>(name: String, value: String?, asNumber: (String)->T?, save: (T?)->Void) {

        // Attempt to convert the given string to a number
        if let value = value?.notEmpty, let number = asNumber(value) {
            // Save the number and update the fields
            save(number)
            self.updateViewForFieldsData(animated: true)
            return
        }

        // If the given string cannot be converted to a number Do not overwrite the saved number

        let title = NSLocalizedString("Not a Number", comment: "")
        let message = NSLocalizedString("The value for \(name) must be a number.", comment: "")

        // Present an alert and reset the number field
        self.router.presentAlert(.init(
            title: title,
            message: message,
            cancelHandler: { [weak self] in
                // Update the fields with the previously saved values
                self?.updateViewForFieldsData(animated: true)
            }
        ))
    }
     */


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

    private func updateViewLoafCount() {
        let loafCount = self.interactor.loafCount
        let loafCountString = self.format(loafCount)
        self.view.setLoafCount(loafCountString)
    }

    private func updateViewQuantityPerLoaf() {
        let quantityPerLoaf = self.interactor.quantityPerLoaf
        let quantityPerLoafString = self.format(quantityPerLoaf)
        self.view.setQuantityPerLoaf(quantityPerLoafString)
    }

    private func updateViewQuantities() {

        var quantityByIndexPath: [IndexPath: String] = [:]

        // Map each quantity to an index path for the view
        for (stageIndex, stage) in self.interactor.stages.enumerated() {
            for (ingredientIndex, ingredient) in stage.ingredients.enumerated() {
                let indexPath = IndexPath(row: ingredientIndex, section: stageIndex)
                let quantity = self.interactor.quantityForIngredient(withId: ingredient.id)
                quantityByIndexPath[indexPath] = self.format(quantity)
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


    // MARK: - Number Formatting


    private func stripToDouble(_ formattedString: String) -> Double? {
        self.formatter.maximumFractionDigits = .max
        return self.formatter.number(from: formattedString)?.doubleValue
    }

    private func stripToInt(_ formattedString: String) -> Int? {
        self.formatter.maximumFractionDigits = 0
        return self.formatter.number(from: formattedString)?.intValue
    }

    private func format(_ double: Double) -> String {

        let fractionDigits: Int

        if (double < 10) {
            fractionDigits = 2
        }
        else if (double < 100) {
            fractionDigits = 1
        }
        else {
            fractionDigits = 0
        }

        self.formatter.minimumFractionDigits = fractionDigits
        self.formatter.maximumFractionDigits = fractionDigits
        return self.formatter.string(from: NSNumber(value: double))!
    }

    private func format(_ int: Int) -> String {

        self.formatter.maximumFractionDigits = 0
        return self.formatter.string(from: NSNumber(value: int))!
    }

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
}
