//
//  RecipeModuleApi.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


// MARK: - View


protocol RecipeViewToPresenter: class {
    func setIsEditing(_ isEditing: Bool)
    func setEditButtonTitle(_ title: String?)
    func setTitle(_ title: String?)
    func setLoafCount(_ loafCount: String?)
    func setQuantityPerLoaf(_ quantityPerLoaf: String?)
}

protocol RecipeStageHeaderProtocol: class {
    func setTitle(_ title: String?)
    func setIsEditing(_ isEditing: Bool)
}

protocol RecipeIngredientCellProtocol: class {
    func setName(_ name: String?)
    func setWeight(_ weight: String?)
    func setQuantity(_ quantity: String?)
    func setIsEditing(_ isEditing: Bool)
}


// MARK: - Presenter


protocol RecipePresenterToView: class {

    func viewDidLoad()
    // Editing
    func didTapEditButton()
    // Field Changess
    func viewDidChangeLoafCount(_ loafCountString: String?)
    func viewDidChangeQuantityPerLoaf(_ quantityPerLoafString: String?)
    func viewDidChangeStageName(_ name: String?, at index: Int)
    func viewDidChangeName(_ name: String?, at indexPath: IndexPath)
    func viewDidChangeWeight(_ weightString: String?, at indexPath: IndexPath)
    // Table Setup
    var numberOfStages: Int { get }
    func numberOfIngredients(forStage stageIndex: Int) -> Int
    func configure(_ header: RecipeStageHeaderProtocol, at index: Int)
    func configure(_ cell: RecipeIngredientCellProtocol, at indexPath: IndexPath)
    func canEditCell(at indexPath: IndexPath) -> Bool
}
