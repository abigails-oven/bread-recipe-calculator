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
        self.mock.input.alertData = data
    }

    func promptForFlourQuantity(title: String, completion: @escaping (Double?)->Void) {
        self.mock.callCounts.promptForFlourQuantity += 1
        self.mock.input.flourQuantity = title
        completion(self.mock.output.flourQuantity)
    }


    // MARK: - Calls


    var mock: Mock = .init()

    struct Mock {

        var callCounts: Count = .init()
        var input: Input = .init()
        var output: Output = .init()

        mutating func clearCallCounts() {
            self.callCounts = .init()
        }

        struct Count {
            var presentAlert: Int = 0
            var promptForFlourQuantity: Int = 0
        }

        struct Input {
            var alertData: AlertData?
            var flourQuantity: String = ""
        }

        struct Output {
            var flourQuantity: Double?
        }
    }
}
