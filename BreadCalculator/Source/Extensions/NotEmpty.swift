//
//  NotEmpty.swift
//
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


protocol NotEmpty {
    var isEmpty: Bool { get }
}


extension NotEmpty {

    var notEmpty: Self? {
        return self.isEmpty ? nil : self
    }
}


extension String: NotEmpty {}
extension Array: NotEmpty {}
extension Set: NotEmpty {}
extension Dictionary: NotEmpty {}
