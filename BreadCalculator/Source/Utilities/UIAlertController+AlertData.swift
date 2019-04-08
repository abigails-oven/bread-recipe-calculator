//
//  UIAlertController+AlertData.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation
import UIKit


extension UIAlertController {

    convenience init(_ data: AlertData) {

        self.init(title: data.title, message: data.message, preferredStyle: .alert)

        // Insert each regular action
        data.actions.forEach{ self.addAction($0) }

        // Insert the cancel action
        if let cancelAction = data.cancelAction {
            self.addCancelAction(cancelAction)
        }
    }

    private func addAction(_ data: AlertData.Action) {

        // Let the alert action's handler capture the only the handler from the data, not the data object itself
        let handler = data.handler

        // Initialize the action
        let action = UIAlertAction(
            title: data.title,
            style: data.isDestructive ? .destructive : .default,
            handler: { _ in handler() }
        )

        self.addAction(action)

        // Only allow the first action marked as preferred to be set
        if data.isPreferred, (self.preferredAction == nil) {
            self.preferredAction = action
        }
    }

    private func addCancelAction(_ data: AlertData.CancelAction) {

        var uiActionHandler: ((UIAlertAction)->Void)?

        // Only create a handler for the cancel action if the given data has a handler
        if let handler = data.handler {
            uiActionHandler = { _ in handler() }
        }

        // Initialize the cancel action
        self.addAction(.init(
            title: data.title,
            style: .cancel,
            handler: uiActionHandler
        ))
    }
}


private extension AlertData.Action {

    var destructured: (title: String, handler: ()->Void, isPreferred: Bool, isDestructive: Bool) {
        return (
            title: self.title,
            handler: self.handler,
            isPreferred: self.isPreferred,
            isDestructive: self.isDestructive
        )
    }
}
