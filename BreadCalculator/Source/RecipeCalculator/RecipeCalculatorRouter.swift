//
//  RecipeCalculatorRouter.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


class RecipeCalculatorRouter: RecipeCalculatorRouterToPresenter {

    // MARK: - Init


    init(_ view: UIViewController) {
        self.view = view
    }

    private weak var view: UIViewController!


    // MARK: - RecipeCalculatorRouterToPresenter


    func presentAlert(_ data: AlertData) {

        let alert = UIAlertController(data)
        self.view.present(alert, animated: true, completion: nil)
    }

}
