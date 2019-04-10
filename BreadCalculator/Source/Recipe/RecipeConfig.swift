//
//  RecipeConfig.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


class RecipeConfig {

    @discardableResult
    init(_ view: RecipeViewController) {

        let presenter = RecipePresenter(view)
        view.presenter = presenter
    }
}
