//
//  RecipeDetailRouter.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/10/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


class RecipeDetailRouter: RecipeDetailRouterToPresenter {

    // MARK: - Init


    init(_ view: UIViewController) {
        self.view = view
    }

    private weak var view: UIViewController!


    // MARK: - RecipeDetailRouterToPresenter


    func dismiss() {
        self.view.dismiss(animated: true, completion: nil)
    }

    func presentAlert(_ data: AlertData) {

        let alert = UIAlertController(data)
        self.view.present(alert, animated: true, completion: nil)
    }
}
