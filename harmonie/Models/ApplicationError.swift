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

    static var appVMIsNotSetError: ApplicationError {
        ApplicationError(text: "App ViewModel is not set")
    }

    static var userIsNotSetError: ApplicationError {
        ApplicationError(text: "User is not set")
    }
}

extension ApplicationError {
    init(_ error: Error) {
        text = error.localizedDescription
    }
}
