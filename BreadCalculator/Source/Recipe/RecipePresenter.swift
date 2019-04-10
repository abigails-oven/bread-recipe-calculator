//
//  RecipePresenter.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


class RecipePresenter: RecipePresenterToView {

    // MARK: - Init


    init(_ view: RecipeViewToPresenter) {
        self.view = view
    }


    // MARK: - Module Accessors


    private weak var view: RecipeViewToPresenter!


    // MARK: - RecipePresenterToView


    func viewDidLoad() {
        self.updateViewEditingAppearance()
        self.view.setTitle(self.recipe.title)
        self.view.setLoafCount("\(self.recipe.loafCount)")
    }

    func viewDidChangeLoafCount(_ loafCountString: String?) {
        // TODO: Update loaf count
    }

    func viewDidChangeQuantityPerLoaf(_ quantityPerLoafString: String?) {
        // TODO: Update quantity per loaf
    }

    func viewDidChangeStageName(_ name: String?, at index: Int) {

        guard let name = name?.notEmpty else {
            // TODO: Show alert and reset
            return
        }

        self.updateStage(at: index) { $0.title = name }
    }

    func viewDidChangeName(_ name: String?, at indexPath: IndexPath) {

        guard let name = name?.notEmpty else {
            // TODO: Show alert and reset
            return
        }

        self.updateIngredient(at: indexPath) { $0.name = name }
    }

    func viewDidChangeWeight(_ weightString: String?, at indexPath: IndexPath) {

        guard let weightString = weightString?.notEmpty else {
            // TODO: Show alert and reset
            return
        }

        guard let weight = Double(weightString) else {
            // TODO: Show alert and reset
            return
        }

        self.updateIngredient(at: indexPath) { $0.weight = weight }
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

    func configure(_ header: RecipeStageHeaderProtocol, at index: Int) {
        let stage = self.stage(at: index)
        header.setTitle(stage.title)
        header.setIsEditing(self.isEditing)
    }

    func configure(_ cell: RecipeIngredientCellProtocol, at indexPath: IndexPath) {
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


    private func updateStage(at index: Int, transform: (inout Recipe.Stage)->Void) {
        var stage = self.recipe.stages.remove(at: index)
        transform(&stage)
        self.recipe.stages.insert(stage, at: index)
    }

    private func updateIngredient(at indexPath: IndexPath, transform: (inout Recipe.Stage.Ingredient)->Void) {
        self.updateStage(at: indexPath.section) { stage in
            var ingredient = stage.ingredients.remove(at: indexPath.row)
            transform(&ingredient)
            stage.ingredients.insert(ingredient, at: indexPath.row)
        }
    }

    private func stage(at index: Int) -> Recipe.Stage {
        return self.recipe.stages[index]
    }

    private func ingredient(at indexPath: IndexPath) -> Recipe.Stage.Ingredient {
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
