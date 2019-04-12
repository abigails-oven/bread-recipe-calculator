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


    func presentAlert(_ data: AlertData) {

        let alert = UIAlertController(data)
        self.view.present(alert, animated: true, completion: nil)
    }

    func promptForFlourQuantity(title: String, completion: @escaping (Double?) -> Void) {

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .decimalPad
            self.textField = textField
        }

        let doneAction = UIAlertAction(
            title: NSLocalizedString("Done", comment: ""),
            style: .default,
            handler: { [weak self] _ in
                if let numberString = self?.textField?.text, let number = Double(numberString) {
                    completion(number)
                }
            }
        )

        alert.addAction(doneAction)

        self.view.present(alert, animated: true, completion: nil)
    }

    private weak var textField: UITextField!
}
