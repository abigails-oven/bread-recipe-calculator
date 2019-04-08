//
//  Collection+Dictionary.swift
//
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

    func compactDictionary<Key: Hashable, Value>(_ keyValue: (Element) throws -> (Key?, Value?)) rethrows -> [Key: Value] {
        return try self.reduce(into: [:]) { (result, element) in
            let (key, value) = try keyValue(element)

            if let key = key, let value = value {
                result[key] = value
            }
        }
    }
}

extension Collection where Element: Hashable {

    func dictionary<Value>(value generateValue: (Element) throws -> Value) rethrows -> [Element: Value] {
        return try self.reduce(into: [:]) { (result, element) in
            result[element] = try generateValue(element)
        }
    }

    func compactDictionary<Value>(value generateValue: (Element) throws -> Value?) rethrows -> [Element: Value] {
        return try self.reduce(into: [:]) { (result, element) in
            if let value = try generateValue(element) {
                result[element] = value
            }
        }
    }
}
