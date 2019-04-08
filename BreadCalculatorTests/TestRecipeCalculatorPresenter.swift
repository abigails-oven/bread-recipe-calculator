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
    private var view: MockRecipeCalculatorView!
    private var interactor: MockRecipeCalculatorInteractor!
    private var router: MockRecipeCalculatorRouter!

    override func setUp() {
        self.view = MockRecipeCalculatorView()
        self.interactor = MockRecipeCalculatorInteractor()
        self.router = MockRecipeCalculatorRouter()
        self.testSubject = RecipeCalculatorPresenter(self.view, self.interactor, self.router)
    }

    // No tear down necessary
    // override func tearDown() {}

    func testViewDidLoad() {

        self.testSubject.viewDidLoad()

        print("------")
        print("Test viewDidLoad:")

        // Assert setup methods are called exactly once
        guard self.assertCallCount(name: "setBreadType", count: self.view.calls.setBreadType.count, expectedCount: 1) else {
            return
        }

        print("  setBreadType was called exactly once")
        guard let setBreadType = self.view.calls.setBreadType.last, (self.view.calls.setBreadType.count == 1) else {
            XCTFail()
            return
        }

        print("  (BreadType: \(setBreadType.breadType.debugName))")

        print("  setBreadType was called WITHOUT animation")
        XCTAssertFalse(setBreadType.animated)

        print("  endEditingField was NOT called")
        XCTAssert(self.view.calls.endEditingField == 0)

        print("------")
    }

    func testChangeBreadType() {

        self.testSubject.viewDidLoad()

        print("------")
        print("Test viewDidChangeBreadType")

        for breadType in BreadType.all {
            let oldSetBreadTypeCount = self.view.calls.setBreadType.count
            let oldEndEditingCount = self.view.calls.endEditingField

            self.testSubject.viewDidChangeBreadType(breadType)

            print("  Changed to \(breadType.debugName)")

            print("    endEditingField was called exactly once")
            let newEndEditingCount = self.view.calls.endEditingField
            let endEditingDelta = (newEndEditingCount - oldEndEditingCount)
            XCTAssert(endEditingDelta == 1, "Called endEditingField \(endEditingDelta) times")

            print("    setBreadType was called exactly once")
            let newSetBreadTypeCount = self.view.calls.setBreadType.count

            guard (newSetBreadTypeCount == oldSetBreadTypeCount + 1) else {
                XCTFail()
                continue
            }

            let setBreadType = self.view.calls.setBreadType.last!

            print("    setBreadType was called WITH animation")
            XCTAssertTrue(setBreadType.animated)
        }

        print("------")
    }


    // MARK: - Assertions


    private func assertCallCount(name: String, count: Int, expectedCount: Int) -> Bool {
        XCTAssert(count == expectedCount, "Called \(name) \(count) times. Expected \(expectedCount).")
        return (count == expectedCount)
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
