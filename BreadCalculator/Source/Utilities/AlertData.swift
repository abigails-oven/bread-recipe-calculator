//
//  AlertData.swift
//  BreadCalculator
//
//  Created by Scott Levie on 4/8/19.
//  Copyright © 2019 Scott Levie. All rights reserved.
//

import Foundation


struct AlertData {

    // MARK: - Init

    init(title: String? = nil, message: String? = nil, actions: [Action] = [], cancelTitle: String? = nil, cancelHandler: (()->Void)? = nil) {
        self.title = title
        self.message = message
        self.actions = actions

        if let cancelTitle = cancelTitle, let cancelHandler = cancelHandler {
            // Replace the cancel action
            self.cancelAction = .init(title: cancelTitle, handler: cancelHandler)
        }
        else if let cancelTitle = cancelTitle {
            // Replace the cancel action title
            self.cancelAction!.title = cancelTitle
        }
        else if let cancelHandler = cancelHandler {
            // Replace the cancel action handler
            self.cancelAction!.handler = cancelHandler
        }
    }

    // MARK: - Title/Message

    var title: String?
    var message: String?

    // MARK: - Actions

    var actions: [Action] = []

    struct Action {
        var title: String
        var handler: ()->Void
        var isPreferred: Bool = false
        var isDestructive: Bool = false
    }

    // MARK: - Cancel Action

    var cancelAction: CancelAction? = AlertData.defaultCancelAction

    struct CancelAction {
        var title: String
        var handler: (()->Void)?
    }

    static let defaultCancelAction: CancelAction = .init(
        title: NSLocalizedString("Cancel", comment: ""),
        handler: nil
    )
}

