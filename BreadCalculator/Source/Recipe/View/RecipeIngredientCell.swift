//
//  RecipeIngredientCell.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


protocol RecipeIngredientCellDelegate {
    func cell(_ cell: RecipeIngredientCell, didChangeName newName: String?)
    func cell(_ cell: RecipeIngredientCell, didChangeWeight newWeight: String?)
}


class RecipeIngredientCell: UITableViewCell, RecipeIngredientCellProtocol, UITextFieldDelegate {

    // MARK: - Reuse Identifier


    static let reuseId: String = "\(RecipeIngredientCell.self)Identifier"


    // MARK: - Nib


    static let nib: UINib = .init(nibName: "\(RecipeIngredientCell.self)", bundle: nil)

    static func initFromNib() -> RecipeIngredientCell {
        let items = self.nib.instantiate(withOwner: nil, options: nil)
        return items.first as! RecipeIngredientCell
    }


    // MARK: - RecipeIngredientCellProtocol


    func setName(_ name: String?) {
        self.nameField?.text = name
    }

    func setWeight(_ weight: String?) {
        self.weightField?.text = weight
    }

    func setQuantity(_ quantity: String?) {
        self.quantityLabel?.text = quantity
    }


    // MARK: - Outlets


    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var weightField: UITextField!
    @IBOutlet private weak var quantityLabel: UILabel!


    // MARK: - Editing


    func setIsEditing(_ isEditing: Bool) {

        self.isUserInteractionEnabled = isEditing

        let appearance = isEditing ? self.editingAppearance : self.regularAppearance

        for field in [self.nameField!, self.weightField!] {
            UIView.transition(with: field, duration: ANIMATION_DURATION, options: .transitionCrossDissolve, animations: {
                field.setAppearance(appearance)
            }, completion: nil)
        }
    }

    private lazy var regularAppearance: UITextField.Appearance = {
        let pointSize = self.quantityLabel.font.pointSize
        return (
            font: UIFont.systemFont(ofSize: pointSize),
            borderStyle: .none,
            textColor: .white,
            backgroundColor: .clear,
            alpha: 1
        )
    }()

    private lazy var editingAppearance: UITextField.Appearance = {
        let pointSize = self.quantityLabel.font.pointSize
        return (
            font: UIFont.systemFont(ofSize: pointSize - 2),
            borderStyle: .roundedRect,
            textColor: .black,
            backgroundColor: .white,
            alpha: 1
        )
    }()
}


private let ANIMATION_DURATION: TimeInterval = 0.08
