//
//  RecipeDetailModuleApi.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


// MARK: - View


protocol RecipeDetailViewToPresenter: class {
    func setIsEditing(_ isEditing: Bool)
    func setEditButtonTitle(_ title: String?)
    func setTitle(_ title: String?)
    func setLoafCount(_ loafCount: String?)
    func setQuantityPerLoaf(_ quantityPerLoaf: String?)
    func setQuantities(_ quantityByIndexPath: [IndexPath: String])
}

protocol RecipeDetailStageHeaderProtocol: class {
    func setIsEditing(_ isEditing: Bool)
    func setTitle(_ title: String?)
}

protocol RecipeDetailIngredientCellProtocol: class {
    func setIsEditing(_ isEditing: Bool)
    func setName(_ name: String?)
    func setWeight(_ weight: String?)
    func setQuantity(_ quantity: String?)
}


// MARK: - Presenter


protocol RecipeDetailPresenterToView: class {

    func viewDidLoad()
    // Editing
    func userDidTapEditButton()
    // Field Changes
    func userDidChangeLoafCount(_ loafCountString: String?)
    func userDidChangeQuantityPerLoaf(_ quantityPerLoafString: String?)
    func userDidChangeStageTitle(_ title: String?, at index: Int)
    func userDidChangeName(_ name: String?, at indexPath: IndexPath)
    func userDidChangeWeight(_ weightString: String?, at indexPath: IndexPath)
    // Table
    var numberOfStages: Int { get }
    func numberOfIngredients(forStage stageIndex: Int) -> Int
    func configure(_ header: RecipeDetailStageHeaderProtocol, at index: Int)
    func configure(_ cell: RecipeDetailIngredientCellProtocol, at indexPath: IndexPath)
    func canEditCell(at indexPath: IndexPath) -> Bool
}


// MARK: - Interactor


protocol RecipeDetailInteractorToPresenter: class {
    func saveRecipe()
    var recipeTitle: String { get set }
    var loafCount: Int { get set }
    var quantityPerLoaf: Double { get set }
    var stages: [RecipeDetail.Stage] { get }
    func setStageTitle(_ title: String, id: UUID)
    func setIngredientName(_ name: String, id: UUID)
    func setIngredientWeight(_ weight: Double, id: UUID)
    func quantityForIngredient(withId id: UUID) -> Double
}

struct RecipeDetail {
    typealias Stage = (id: UUID, title: String, ingredients: [Ingredient])
    typealias Ingredient = (id: UUID, name: String, weight: Double)
}
