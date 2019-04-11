//
//  TestRecipeDetailPresenter.swift
//  BreadCalculatorTests
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import XCTest
@testable import BreadCalculator

class TestRecipeDetailPresenter: XCTestCase {

    private var testSubject: RecipeDetailPresenterToView!
    private var view: MockRecipeDetailView!
    private var interactor: MockRecipeDetailInteractor!
    private var router: MockRecipeDetailRouter!

    override func setUp() {
        self.view = MockRecipeDetailView()
        self.interactor = MockRecipeDetailInteractor()
        self.router = MockRecipeDetailRouter()
        self.testSubject = RecipeDetailPresenter(self.view, self.interactor, self.router)
    }

    // No tear down necessary
    // override func tearDown() {}

    func testViewDidLoad() {

        self.testSubject.viewDidLoad()

        // Assert setup methods are called exactly once
        let counts = self.view.mock.callCounts
        XCTAssert(counts.setEditButtonTitle == 1)
        XCTAssert(counts.setIsEditing == 1)
        XCTAssert(counts.setTitle == 1)
        XCTAssert(counts.setLoafCount == 1)
        XCTAssert(counts.setQuantityPerLoaf == 1)
    }

    func testUserDidTapEditButton() {

        self.testSubject.viewDidLoad()

        let oldCounts = self.view.mock.callCounts
        let oldValues = self.view.mock.values

        self.testSubject.userDidTapEditButton()

        let values = self.view.mock.values
        // Assert isEditing was toggled
        XCTAssert(values.isEditing == !oldValues.isEditing)

        let counts = self.view.mock.callCounts
        // Assert setEditButtonTitle was called exactly once
        XCTAssert((counts.setEditButtonTitle - oldCounts.setEditButtonTitle) == 1)
        // Assert setIsEditing was called exactly once
        XCTAssert((counts.setIsEditing - oldCounts.setIsEditing) == 1)
    }
}
