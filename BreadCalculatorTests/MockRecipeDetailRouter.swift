//
//  MockRecipeDetailRouter.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
@testable import BreadCalculator


class MockRecipeDetailRouter: RecipeDetailRouterToPresenter {

    // MARK: - RecipeDetailRouterToPresenter


    func presentAlert(_ data: AlertData) {
        self.mock.callCounts.presentAlert += 1
        self.mock.values.presentAlertData = data
    }

    func promptForFlourQuantity(title: String, completion: @escaping (String?)->Void) {
        self.mock.callCounts.promptForFlourQuantity += 1
        self.mock.values.promptForFlourQuantityTitle = title
        completion(self.mock.values.promptForFlourQuantityCompletionValue)
    }


    // MARK: - Calls


    var mock: Mock = .init()

    struct Mock {

        var callCounts: Count = .init()
        var values: Values = .init()

        struct Count {
            var presentAlert: Int = 0
            var promptForFlourQuantity: Int = 0
        }

        struct Values {
            var presentAlertData: AlertData?
            var promptForFlourQuantityTitle: String = ""
            var promptForFlourQuantityCompletionValue: String?
        }
    }
}
