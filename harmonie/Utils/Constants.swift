//
//  Constants.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/22.
//

import SwiftUI

enum Constants {
    enum Keys {
        static let isSavedOnKeyChain = "isSavedOnKeyChain"
        static let username = "username"
    }

    enum Values {
        static let previewUser = "demonstration"
    }

    enum MaxCountInFavoriteList: Int, CustomStringConvertible {
        case friends = 150
        case world = 100
        var description: String { rawValue.description }
    }

    enum IconSize {
        static let thumbnail = CGSize(width: 32, height: 32)
        static let indicator = CGSize(width: 20, height: 20)
        static let ll = CGSize(width: 44, height: 44)
    }

    enum Messages {
        case helpWithVRChatAPIAuthencication
        case helpWithStoringAuthenticationTokens
        case helpWithStoringPassword
        case helpWithCommunicationSecurity

        var text: String {
            switch self {
            case .helpWithVRChatAPIAuthencication:
                value(key: "msg_help_with_vrchat_api_authentication")
            case .helpWithStoringAuthenticationTokens:
                value(key: "msg_help_with_storing_authentication_tokens")
            case .helpWithStoringPassword:
                value(key: "msg_help_with_storing_password")
            case .helpWithCommunicationSecurity:
                value(key: "msg_help_with_communication_security")
            }
        }

        public func value(key: String.LocalizationValue) -> String {
            String(localized: key, table: "Message")
        }
    }
}
