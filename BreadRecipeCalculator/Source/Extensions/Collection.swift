//
//  Collection.swift
//  BreadRecipeCalculator
//
//  Created by Scott Levie on 3/27/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


extension Collection {

    func dictionary<Key: Hashable>(key generateKey: (Element) throws -> Key?) rethrows -> [Key: Element] {
        return try self.reduce(into: [:]) { (result, element) in
            if let key = try generateKey(element) {
                result[key] = element
            }
        }
    }

    func dictionary<Key: Hashable, Value>(_ keyValue: (Element) throws -> (Key, Value)) rethrows -> [Key: Value] {
        return try self.reduce(into: [:]) { (result, element) in
            let (key, value) = try keyValue(element)
            result[key] = value
        }
    }

    func flatDictionary<Key: Hashable, Value>(_ keyValue: (Element) throws -> (Key?, Value?)) rethrows -> [Key: Value] {
        return try self.reduce(into: [:]) { (result, element) in
            let (key, value) = try keyValue(element)

            if let key = key, let value = value {
                result[key] = value
            }
        }
    }
}
