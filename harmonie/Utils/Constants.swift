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
        static let helpWithStoringKeychain = String(localized: "msg_help_with_storing_keychain", table: "Message")
        static let helpWithLoginSafety = String(localized: "msg_help_with_login_safety", table: "Message")
    }
}
