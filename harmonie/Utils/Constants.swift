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

    enum IconSize {
        static let thumbnail = CGSize(width: 32, height: 32)
        static let indicator = CGSize(width: 20, height: 20)
        static let ll = CGSize(width: 44, height: 44)
    }

    enum Messages {
        static let helpWithStoringKeychain = """
            Using iCloud Keychain to securely store your passwords. \
            iCloud Keychain is built on security technologies provided by Apple, \
            ensuring that your passwords are encrypted \
            and protected from unauthorized access.
            """
    }
}
