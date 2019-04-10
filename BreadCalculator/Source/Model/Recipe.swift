//
//  Recipe.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


class Recipe {

    let id: UUID = .init()
    var title: String
    var loafCount: Int
    var quantityPerLoaf: Double
    var stages: [Stage] = []

    init(title: String = "", loafCount: Int = 2, quantityPerLoaf: Double = 2, stages: [Stage] = []) {
        self.title = title
        self.loafCount = loafCount
        self.quantityPerLoaf = quantityPerLoaf
        self.stages = stages
    }

    private static let placeholder: String = NSLocalizedString("Dough Name", comment: "")

    class Stage: Codable {

        let id: UUID = .init()
        var title: String
        var ingredients: [Ingredient]

        init(title: String = "", ingredients: [Ingredient] = []) {
            self.title = title
            self.ingredients = ingredients
        }

        static let placeholder = NSLocalizedString("Stage Name", comment: "")
    }

    class Ingredient: Codable {

        let id: UUID = .init()
        var name: String
        var weight: Double

        init(name: String = "", weight: Double = 0) {
            self.name = name
            self.weight = weight
        }

        static let placeholder = NSLocalizedString("Ingredient", comment: "")
    }
}
