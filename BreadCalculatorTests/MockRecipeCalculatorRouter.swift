//
//  MockRecipeCalculatorRouter.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
@testable import BreadCalculator


class MockRecipeCalculatorRouter: RecipeCalculatorRouterToPresenter {

    // MARK: - RecipeCalculatorRouterToPresenter


    func presentAlert(_ data: AlertData) {
        self.calls.presentAlert.append(data)
    }


    // MARK: - Calls


    private(set) var calls: Calls = .init()

    struct Calls {

        var presentAlert: [AlertData] = []
    }
}
