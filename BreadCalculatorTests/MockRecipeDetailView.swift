//
//  MockRecipeDetailView.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

@testable import BreadCalculator
import Foundation


class MockRecipeDetailView: RecipeDetailViewToPresenter {

    // MARK: - RecipeDetailViewToPresenter


    func setIsEditing(_ isEditing: Bool) {
        self.mock.callCounts.setIsEditing += 1
        self.mock.values.isEditing = isEditing
    }

    func setEditButtonTitle(_ title: String?) {
        self.mock.callCounts.setEditButtonTitle += 1
        self.mock.values.editButtonTitle = title
    }

    func setTitle(_ title: String?) {
        self.mock.callCounts.setTitle += 1
        self.mock.values.title = title
    }

    func setLoafCount(_ loafCount: String?) {
        self.mock.callCounts.setLoafCount += 1
        self.mock.values.loafCount = loafCount
    }

    func setQuantityPerLoaf(_ quantityPerLoaf: String?) {
        self.mock.callCounts.setQuantityPerLoaf += 1
        self.mock.values.quantityPerLoaf = quantityPerLoaf
    }

    func setQuantities(_ quantityByIndexPath: [IndexPath: String]) {
        self.mock.callCounts.setQuantities += 1
        self.mock.values.quantities = quantityByIndexPath
    }


    // MARK: - Mock Data


    var mock: Mock = .init()

    struct Mock {

        var callCounts: Counts = .init()
        var values: Values = .init()

        struct Counts {
            var setIsEditing: Int = 0
            var setEditButtonTitle: Int = 0
            var setTitle: Int = 0
            var setLoafCount: Int = 0
            var setQuantityPerLoaf: Int = 0
            var setQuantities: Int = 0
        }

        struct Values {
            var isEditing: Bool = false
            var editButtonTitle: String?
            var title: String?
            var loafCount: String?
            var quantityPerLoaf: String?
            var quantities: [IndexPath: String] = [:]
        }
    }
}
