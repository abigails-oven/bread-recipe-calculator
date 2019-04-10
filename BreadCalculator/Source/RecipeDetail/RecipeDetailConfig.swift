//
//  RecipeDetailConfig.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


class RecipeDetailConfig {

    @discardableResult
    init(_ view: RecipeDetailViewController, _ recipe: Recipe) {

        let interactor = RecipeDetailInteractor(recipe)
        let presenter = RecipeDetailPresenter(view, interactor)
        view.presenter = presenter
    }
}
