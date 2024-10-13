//
//  ApplicationError.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/23.
//

import Foundation

struct ApplicationError: LocalizedError {
    let text: String

    var localizedString: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: text)
    }

    var errorDescription: String? {
        String(localized: localizedString)
    }

    static var UserIsNotSetError: ApplicationError {
        ApplicationError(text: "User is not set")
    }
}
