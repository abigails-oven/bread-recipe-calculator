//
//  TestRecipeCalculatorPresenter.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import XCTest
@testable import BreadCalculator

class TestRecipeCalculatorPresenter: XCTestCase {

    private var testSubject: RecipeCalculatorPresenterToView!
    private var interactor: MockRecipeCalculatorInteractor!
    private var view: MockRecipeCalculatorView!

    override func setUp() {
        self.view = MockRecipeCalculatorView()
        self.interactor = MockRecipeCalculatorInteractor()
        self.testSubject = RecipeCalculatorPresenter(self.view, self.interactor)
    }

    // No tear down necessary
    // override func tearDown() {}

    func testViewDidLoad() {

        self.testSubject.viewDidLoad()

        // Assert setBreadType called once
        print("Test: setBreadType is called exactly once")
        guard (self.view.callsToSetBreadType.count == 1) else {
            XCTFail()
            return
        }

        let breadType = self.view.callsToSetBreadType.first!
        print("BreadType: \(breadType.debugName)")

        // Assert hideFlourSecondary called once
        print("Test hideFlourSecondary: Is called exactly once")
        guard (self.view.callsToHideFlourSecondary.count == 1) else {
            XCTFail()
            return
        }

        let hideFlour2 = self.view.callsToHideFlourSecondary.first!

        // Assert hideFlourSecondary matches setting for bread type
        print("Test hideFlourSecondary: shouldHide == \(breadType.debugName) setting (\(breadType.hideFlourSecondary))")
        XCTAssert(hideFlour2.shouldHide == breadType.hideFlourSecondary)

        // Assert hideFlourSecondary is not animated
        print("Test hideFlourSecondary: animated == false")
        XCTAssertFalse(hideFlour2.animated)

        // Assert hideWaterStage2 called once
        print("Test hideWaterStage2: Is called exactly once")
        guard (self.view.callsToHideWaterStage2.count == 1) else {
            XCTFail()
            return
        }

        let hideWater2 = self.view.callsToHideWaterStage2.first!

        // Assert hideWaterStage2 matches setting for bread type
        print("Test hideWaterStage2: shouldHide == \(breadType.debugName) setting (\(breadType.hideWaterStage2))")
        XCTAssert(hideWater2.shouldHide == breadType.hideWaterStage2)

        // Assert hideWaterStage2 is not animated
        print("Test hideWaterStage2: animated == false")
        XCTAssertFalse(hideWater2.animated)
    }
}


private extension BreadType {

    var debugName: String {
        switch self {
        case .wheat: return "wheat"
        case .kamut: return "kamut"
        case .sourdough: return "sourdough"
        case .bran: return "bran"
        }
    }

    var ingredients: Set<IngredientType> {
        switch self {
        case .wheat: return [.flourPrimary, .waterStage1, .waterStage2, .leaven, .salt]
        case .kamut: return [.flourPrimary, .waterStage1, .waterStage2, .leaven, .salt]
        case .sourdough: return [.flourPrimary, .flourSecondary, .waterStage1, .waterStage2, .leaven, .salt]
        case .bran: return [.flourPrimary, .waterStage1, .leaven, .salt]
        }
    }

    var hideFlourSecondary: Bool {
        switch self {
        case .wheat, .kamut, .bran:
            return true
        case .sourdough:
            return false
        }
    }

    var hideStage2Separator: Bool {
        switch self {
        case .wheat, .kamut, .sourdough:
            return false
        case .bran:
            return true
        }
    }

    var hideWaterStage2: Bool {
        switch self {
        case .wheat, .kamut, .sourdough:
            return false
        case .bran:
            return true
        }
    }
}
