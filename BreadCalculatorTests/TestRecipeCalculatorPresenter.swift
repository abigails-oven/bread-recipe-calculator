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

        // Assert setup methods are called exactly once
        var calledOnce = true

        calledOnce &&= self.assertCallCount(name: "setBreadType", count: self.view.callsToSetBreadType.count, expectedCount: 1)
        calledOnce &&= self.assertCallCount(name: "hideFlourSecondary", count: self.view.callsToHideFlourSecondary.count, expectedCount: 1)
        calledOnce &&= self.assertCallCount(name: "hideWaterStage2", count: self.view.callsToHideWaterStage2.count, expectedCount: 1)

        guard calledOnce else {
            return
        }

        self.assertViewCallsForBreadType()
    }

    private func assertCallCount(name: String, count: Int, expectedCount: Int) -> Bool {
        XCTAssert(count == expectedCount, "Called \(name) \(count) times. Expected \(expectedCount).")
        return (count == expectedCount)
    }

    private func assertViewCallsForBreadType() {

        let breadType = self.view.callsToSetBreadType.first!
        print("BreadType: \(breadType.debugName)")

        guard let hideFlour2 = self.view.callsToHideFlourSecondary.first else {
            XCTFail()
            return
        }

        // Assert hideFlourSecondary matches setting for bread type
        print("Test hideFlourSecondary: shouldHide == \(breadType.debugName) setting (\(breadType.hideFlourSecondary))")
        XCTAssert(hideFlour2.shouldHide == breadType.hideFlourSecondary)

        // Assert hideFlourSecondary is not animated
        print("Test hideFlourSecondary: animated == false")
        XCTAssertFalse(hideFlour2.animated)

        guard let hideWater2 = self.view.callsToHideWaterStage2.first else {
            XCTFail()
            return
        }

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
