//
//  Dictionary.swift
//  BreadCalculator
//
//  Created by Scott Levie on 3/26/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


extension Dictionary {

    public func mapValuesWithKey<T>(_ transform: (Key, Value) throws -> T) rethrows -> [Key : T] {
        return try self.reduce(into: [:]) { (result, keyValue) in
            let (key, value) = keyValue
            result[key] = try transform(key, value)
        }
    }

    public func mapKeyValues<NewKey: Hashable, NewValue>(_ transform: ((Key, Value) throws -> (NewKey, NewValue))) rethrows -> [NewKey: NewValue] {
        return try self.reduce(into: [:]) { (result, keyValue) in
            let (key, value) = keyValue
            let (newKey, newValue) = try transform(key, value)
            result[newKey] = newValue
        }
    }

    public func flatMapKeyValues<NewKey: Hashable, NewValue>(_ transform: ((Key, Value) throws -> (NewKey?, NewValue?))) rethrows -> [NewKey: NewValue] {

        return try self.reduce(into: [:]) { (result, keyValue) in
            let (key, value) = keyValue
            let (newKey, newValue) = try transform(key, value)

            if let newKey = newKey, let newValue = newValue {
                result[newKey] = newValue
            }
        }
    }
}
