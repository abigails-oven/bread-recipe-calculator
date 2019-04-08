//
//  MockRecipeCalculatorView.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

@testable import BreadCalculator
import Foundation


class MockRecipeCalculatorView: RecipeCalculatorViewToPresenter {

    // MARK: - RecipeCalculatorViewToPresenter


    func endEditingField() {
        self.calls.endEditingField += 1
    }

    func setBreadType(_ breadType: BreadType, title: String, hideStage2Separator: Bool, fieldsData: RecipeCalculatorViewData, animated: Bool) {
        self.calls.setBreadType.append((breadType, title, hideStage2Separator, fieldsData, animated))
    }

    func setFieldsData(_ fieldData: RecipeCalculatorViewData, animated: Bool) {
        self.calls.setFieldsData.append((fieldData, animated))
    }


    // MARK: - Mock Function Calls


    private(set) var calls: Calls = .init()

    struct Calls {

        typealias SetBreadType = (breadType: BreadType, title: String, hideStage2Separator: Bool, fieldsData: RecipeCalculatorViewData, animated: Bool)
        typealias SetFieldsData = (fieldData: RecipeCalculatorViewData, animated: Bool)

        var endEditingField: Int = 0
        var setBreadType: [SetBreadType] = []
        var setFieldsData: [SetFieldsData] = []
    }
}
