//
//  RecipeCalculatorConfig.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation

struct RecipeCalculatorConfig {

    @discardableResult
    init(_ view: RecipeCalculatorViewController) {

        let interactor = RecipeCalculatorInteractor()

        let presenter = RecipeCalculatorPresenter(view, interactor)

        view.presenter = presenter
    }
}
