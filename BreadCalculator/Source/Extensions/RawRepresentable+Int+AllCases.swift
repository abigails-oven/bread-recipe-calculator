//
//  RawRepresentable+Int+AllCases.swift
//
//
//  Created by Scott Levie on 4/1/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


extension RawRepresentable where RawValue == Int {

    static func generateAllSequentialCases(start: Int = 0) -> [Self] {

        var i = start
        var cases: [Self] = []

        while let `case` = Self.init(rawValue: i) {
            cases.append(`case`)
            i += 1
        }

        return cases
    }
}
