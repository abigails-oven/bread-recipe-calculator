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

        // Set Mock Output

        self.router.mock.output.flourQuantity = 20

        self.interactor.mock.output.recipeTitle = "Test Bread Title"
        self.interactor.mock.output.loafCount = 3
        self.interactor.mock.output.quantityPerLoaf = 4
        self.interactor.mock.output.quantityForIngredient = 5

        self.interactor.mock.output.stages = [
            (UUID(), "Stage 1", [
                (UUID(), "Ingredient 1", weight: 1),
                (UUID(), "Ingredient 2", weight: 1),
            ]),
            (UUID(), "Stage 2", [
                (UUID(), "Ingredient 3", weight: 1),
                (UUID(), "Ingredient 4", weight: 1),
            ])
        ]
    }

    // No tear down necessary
    // override func tearDown() {}

    func testViewDidLoad() {

        self.testSubject.viewDidLoad()

        // Assert view methods are called exactly once
        let counts = self.view.mock.callCounts
        XCTAssert(counts.setEditButtonTitle == 1)
        XCTAssert(counts.setIsEditing == 1)
        XCTAssert(counts.setTitle == 1)
        XCTAssert(counts.setLoafCount == 1)
        XCTAssert(counts.setQuantityPerLoaf == 1)

        // Assert 'isEditing' is false by default
        let input = self.view.mock.input
        XCTAssert(input.isEditing == false)

        // Assert the correct title was given to the view
        let output = self.interactor.mock.output
        XCTAssert(input.title == output.recipeTitle)
    }

    func testUserDidTapEditButton() {

        // Setup module state
        self.testSubject.viewDidLoad()

        // Before method call: Record 'isEditing'
        let oldIsEditing = self.view.mock.input.isEditing
        // Before method call: Clear the call counts
        self.view.mock.clearCallCounts()

        // When: User taps the "Edit" button
        self.testSubject.userDidTapEditButton()

        // Assert 'isEditing' was toggled
        let input = self.view.mock.input
        XCTAssert(input.isEditing == !oldIsEditing)

        // Assert each method was called exactly once
        let counts = self.view.mock.callCounts
        XCTAssert(counts.setIsEditing == 1)
        XCTAssert(counts.setEditButtonTitle == 1)
    }

    func testUserDidTapSolveForFlourButton() {

        // Setup module state
        self.testSubject.viewDidLoad()

        // Clear the call counts before the method call
        self.view.mock.clearCallCounts()

        // When: User taps the "Solve for Flour" button
        self.testSubject.userDidTapSolveForFlourButton()

        // Assert 'solveForFlourQuantity' was called exactly once
        XCTAssert(self.interactor.mock.callCounts.solveForFlourQuantity == 1)

        // Assert 'solveForFlourQuantity' was called with the expected input
        XCTAssert(self.interactor.mock.input.flourQuantity == self.router.mock.output.flourQuantity)

        // Assert that the presenter called the view methods exactly once
        let viewCounts = self.view.mock.callCounts
        XCTAssert(viewCounts.setLoafCount == 1)
        XCTAssert(viewCounts.setQuantityPerLoaf == 1)
        XCTAssert(viewCounts.setQuantities == 1)
    }

    func testUserDidChangeLoafCount() {

    }

    func testUserDidChangeQuantityPerLoaf() {

    }

    func testUserDidChangeStageTitle() {

    }

    func testUserDidChangeName() {

    }

    func testUserDidChangeWeight() {

    }

    /*
    var numberOfStages: Int { get }
    func numberOfIngredients(forStage stageIndex: Int) -> Int
    func configure(_ header: RecipeDetailStageHeaderProtocol, at index: Int)
    func configure(_ cell: RecipeDetailIngredientCellProtocol, at indexPath: IndexPath)
    func canEditCell(at indexPath: IndexPath) -> Bool
     */
}
