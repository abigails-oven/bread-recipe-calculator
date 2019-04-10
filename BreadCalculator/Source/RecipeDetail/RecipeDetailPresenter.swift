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


    init(_ view: RecipeDetailViewToPresenter) {
        self.view = view
    }


    // MARK: - Module Accessors


    private weak var view: RecipeDetailViewToPresenter!


    // MARK: - RecipeDetailPresenterToView


    func viewDidLoad() {
        self.updateViewEditingAppearance()
        self.view.setTitle(self.recipe.title)
        self.view.setLoafCount("\(self.recipe.loafCount)")
    }

    func viewDidChangeLoafCount(_ loafCountString: String?) {

        guard let loafCountString = loafCountString?.notEmpty, let loafCount = Int(loafCountString) else {
            // TODO: Show alert and reset
            return
        }

        self.recipe.loafCount = loafCount
    }

    func viewDidChangeQuantityPerLoaf(_ quantityPerLoafString: String?) {

        guard let quantityPerLoafString = quantityPerLoafString?.notEmpty, let quantityPerLoaf = Double(quantityPerLoafString) else {
            // TODO: Show alert and reset
            return
        }

        self.recipe.quantityPerLoaf = quantityPerLoaf
    }

    func viewDidChangeStageName(_ name: String?, at index: Int) {

        guard let name = name?.notEmpty else {
            // TODO: Show alert and reset
            return
        }

        self.stage(at: index).title = name
    }

    func viewDidChangeName(_ name: String?, at indexPath: IndexPath) {

        guard let name = name?.notEmpty else {
            // TODO: Show alert and reset
            return
        }

        self.ingredient(at: indexPath).name = name
    }

    func viewDidChangeWeight(_ weightString: String?, at indexPath: IndexPath) {

        guard let weightString = weightString?.notEmpty, let weight = Double(weightString) else {
            // TODO: Show alert and reset
            return
        }

        self.ingredient(at: indexPath).weight = weight
    }

    private(set) var isEditing: Bool = false

    func didTapEditButton() {
        // Toggle edit mode
        self.isEditing = !self.isEditing
        self.updateViewEditingAppearance()
    }

    var numberOfStages: Int {
        return self.recipe.stages.count
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
        cell.setName(ingredient.name)
        cell.setWeight("\(ingredient.weight)")
        cell.setQuantity("4")
        cell.setIsEditing(self.isEditing)
    }

    func canEditCell(at indexPath: IndexPath) -> Bool {
        return true
    }


    // MARK: - Edit


    private func updateViewEditingAppearance() {

        // Set button title
        let strings = self.localizedStrings.editButton
        let title = self.isEditing ? strings.done : strings.edit
        self.view.setEditButtonTitle(title)

        self.view.setIsEditing(self.isEditing)
    }


    // MARK: - Test


    private func stage(at index: Int) -> Recipe.Stage {
        return self.recipe.stages[index]
    }

    private func ingredient(at indexPath: IndexPath) -> Recipe.Ingredient {
        let stage = self.stage(at: indexPath.section)
        return stage.ingredients[indexPath.row]
    }

    private var recipe: Recipe = .init(
        title: "Fancy Recipe",
        stages: [
            .init(
                title: "First Stage",
                ingredients: [.init(name: "Flour", weight: 3)]
            ),
            .init(
                title: "Second Stage",
                ingredients: [.init(name: "Water", weight: 3)]
            )
        ]
    )


    // MARK: - Localized Strings


    private let localizedStrings = LocalizedStrings()

    private struct LocalizedStrings {
        let editButton = EditButton()

        struct EditButton {
            let edit = NSLocalizedString("Edit", comment: "")
            let done = NSLocalizedString("Done", comment: "")
        }
    }
}
