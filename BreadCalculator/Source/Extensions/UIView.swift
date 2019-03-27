//
//  UIView.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    var firstResponder: UIView? {

        if self.isFirstResponder {
            return self
        }

        for view in self.subviews {
            if let firstResponder = view.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
