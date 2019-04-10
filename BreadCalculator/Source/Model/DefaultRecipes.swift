//
//  DefaultRecipes.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/9/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


extension Recipe {

    static let defaultRecipes: [Recipe] = [.wheat, .kamut, .whiteSourdough, .bran]

    static let wheat: Recipe = .init(title: Localized.wheatTitle, stages: [
        .init(title: Localized.stage1, ingredients: [
            .init(name: Localized.siftedWheatFlour, weight: 100, isFlour: true),
            .init(name: Localized.water, weight: 70),
            .init(name: Localized.leaven, weight: 20)
        ]),
        .init(title: Localized.stage2, ingredients: [
            .init(name: Localized.water, weight: 5),
            .init(name: Localized.salt, weight: 2.6)
        ])
    ])

    static let kamut: Recipe = .init(title: Localized.kamutTitle, stages: [
        .init(title: Localized.stage1, ingredients: [
            .init(name: Localized.kamutFlour, weight: 100, isFlour: true),
            .init(name: Localized.water, weight: 63),
            .init(name: Localized.leaven, weight: 20)
        ]),
        .init(title: Localized.stage2, ingredients: [
            .init(name: Localized.water, weight: 5),
            .init(name: Localized.salt, weight: 2.6)
        ])
    ])

    static let whiteSourdough: Recipe = .init(title: Localized.whiteSourdoughTitle, stages: [
        .init(title: Localized.stage1, ingredients: [
            .init(name: Localized.whiteFlour, weight: 90, isFlour: true),
            .init(name: Localized.wheatFlour, weight: 10, isFlour: true),
            .init(name: Localized.water, weight: 60),
            .init(name: Localized.leaven, weight: 20)
        ]),
        .init(title: Localized.stage2, ingredients: [
            .init(name: Localized.water, weight: 5),
            .init(name: Localized.salt, weight: 2.6)
        ])
    ])

    static let bran: Recipe = .init(title: Localized.branTitle, stages: [
        .init(title: "", ingredients: [
            .init(name: Localized.branFlour, weight: 100, isFlour: true),
            .init(name: Localized.water, weight: 100),
            .init(name: Localized.leaven, weight: 20),
            .init(name: Localized.salt, weight: 2.6)
        ])
    ])

    private struct Localized {

        static let wheatTitle = NSLocalizedString("Naturally Leavened Wheat", comment: "")
        static let siftedWheatFlour = NSLocalizedString("Sifted Wheat Flour", comment: "")

        static let kamutTitle = NSLocalizedString("Naturally Leavened Kamut", comment: "")
        static let kamutFlour = NSLocalizedString("Kamut Flour", comment: "")

        static let whiteSourdoughTitle = NSLocalizedString("White Sourdough", comment: "")
        static let whiteFlour = NSLocalizedString("White Flour", comment: "")
        static let wheatFlour = NSLocalizedString("Wheat Flour", comment: "")

        static let branTitle = NSLocalizedString("Bran Dough", comment: "")
        static let branFlour = NSLocalizedString("Bran Flour", comment: "")

        static let stage1 = NSLocalizedString("Mix and let stand 30 min", comment: "")
        static let stage2 = NSLocalizedString("Stage 2", comment: "")

        static let leaven = NSLocalizedString("Leaven", comment: "")
        static let water1 = NSLocalizedString("First Water", comment: "")
        static let water2 = NSLocalizedString("Second Water", comment: "")
        static let water = NSLocalizedString("Water", comment: "")
        static let salt = NSLocalizedString("Salt", comment: "")
    }
}
