//
//  Bool.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/28/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


infix operator &&=

func &&=(left: inout Bool, right: Bool) {
    left = left && right
}
