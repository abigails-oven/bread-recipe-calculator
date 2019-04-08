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

        let router = RecipeCalculatorRouter(view)

        let presenter = RecipeCalculatorPresenter(view, interactor, router)

        view.presenter = presenter
    }
}
