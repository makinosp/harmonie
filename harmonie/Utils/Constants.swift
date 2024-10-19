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
    }
}

extension Constants.Messages {
    var title: String {
        switch self {
        case .helpWithVRChatAPIAuthencication:
            String(localized: "About the authentication method of VRChatAPI", table: "Message")
        case .helpWithStoringAuthenticationTokens:
            String(localized: "Security in Authentication Token Retention", table: "Message")
        case .helpWithStoringPassword:
            String(localized: "Security in password storage", table: "Message")
        case .helpWithCommunicationSecurity:
            String(localized: "Communication security", table: "Message")
        }
    }

    var text: String {
        switch self {
        case .helpWithVRChatAPIAuthencication:
            String(localized: "msg_help_with_vrchat_api_authentication", table: "Message")
        case .helpWithStoringAuthenticationTokens:
            String(localized: "msg_help_with_storing_authentication_tokens", table: "Message")
        case .helpWithStoringPassword:
            String(localized: "msg_help_with_storing_password", table: "Message")
        case .helpWithCommunicationSecurity:
            String(localized: "msg_help_with_communication_security", table: "Message")
        }
    }
}
