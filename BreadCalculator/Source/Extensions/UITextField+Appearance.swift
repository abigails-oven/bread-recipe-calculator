//
//  UITextField+Appearance.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/9/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


extension UITextField {

    func setAppearance(_ appearance: Appearance) {
        let (font, borderStyle, textColor, backgroundColor, alpha) = appearance
        self.font = font
        self.borderStyle = borderStyle
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.alpha = alpha
    }

    typealias Appearance = (
        font: UIFont,
        borderStyle: BorderStyle,
        textColor: UIColor,
        backgroundColor: UIColor,
        alpha: CGFloat
    )
}
