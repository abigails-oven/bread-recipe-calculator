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
        guard self.assertCallCount(name: "setBreadType", count: self.view.calls.setBreadType.count, expectedCount: 1) else {
            return
        }

        self.assertViewCallsForBreadType()
    }

    private func assertCallCount(name: String, count: Int, expectedCount: Int) -> Bool {
        XCTAssert(count == expectedCount, "Called \(name) \(count) times. Expected \(expectedCount).")
        return (count == expectedCount)
    }

    private func assertViewCallsForBreadType() {

        guard let setBreadType = self.view.calls.setBreadType.first else {
            XCTFail()
            return
        }

        // Assert animated is false
        print("Test setBreadType.animated == false")
        XCTAssertFalse(setBreadType.animated)
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
}
