//
//  RecipeStageHeader.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/9/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


class RecipeStageHeader: UIView, RecipeStageHeaderProtocol {

    static func initFromNib() -> RecipeStageHeader {
        let nib = UINib(nibName: "\(RecipeStageHeader.self)", bundle: nil)
        let nibItems = nib.instantiate(withOwner: nil, options: nil)
        return nibItems.first as! RecipeStageHeader
    }


    // MARK: - RecipeStageHeaderProtocol


    func setTitle(_ title: String?) {
        self.titleField.text = title
    }

    func setIsEditing(_ isEditing: Bool) {

        self.isUserInteractionEnabled = isEditing

        let appearance = isEditing ? self.editingAppearance : self.regularAppearance

        UIView.transition(with: self.titleField, duration: ANIMATION_DURATION, options: .transitionCrossDissolve, animations: {
            self.titleField.setAppearance(appearance)
        }, completion: nil)
    }


    // MARK: - Title


    @IBOutlet private weak var titleField: UITextField!


    // MARK: - Editing


    private lazy var regularAppearance: UITextField.Appearance = {
        let pointSize = self.titleField.font!.pointSize
        return (
            font: UIFont.systemFont(ofSize: pointSize, weight: .bold),
            borderStyle: .none,
            textColor: .white,
            backgroundColor: .clear,
            alpha: 0.5
        )
    }()

    private lazy var editingAppearance: UITextField.Appearance = {
        let pointSize = self.titleField.font!.pointSize
        return (
            font: UIFont.systemFont(ofSize: pointSize, weight: .regular),
            borderStyle: .roundedRect,
            textColor: .black,
            backgroundColor: .white,
            alpha: 1
        )
    }()
}


private let ANIMATION_DURATION: TimeInterval = 0.08
