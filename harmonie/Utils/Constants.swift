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
        static let previewUser = "demo"
    }

    enum Icon {
        static var check: some View {
            Image(systemName: "checkmark")
        }
        static var circleFilled: some View {
            Image(systemName: "circle.fill")
        }
        static var dots: some View {
            Image(systemName: "ellipsis.circle")
        }
        static var down: some View {
            Image(systemName: "arrow.down")
        }
        static var exclamation: some View {
            Image(systemName: "exclamationmark")
        }
        static var favorite: some View {
            Image(systemName: "star")
        }
        static var favoriteFilled: some View {
            Image(systemName: "star.fill")
        }
        static var filter: some View {
            Image(systemName: "line.3.horizontal.decrease")
        }
        static var forward: some View {
            Image(systemName: "chevron.forward")
                .foregroundStyle(Color(uiColor: .tertiaryLabel))
                .imageScale(.small)
        }
        static var friends: some View {
            Image(systemName: "person.2.fill")
        }
        static var location: some View {
            Image(systemName: "location")
        }
        static var setting: some View {
            Image(systemName: "gear")
        }
        static var shield: some View {
            Image(systemName: "shield.fill")
        }
        static var sort: some View {
            Image(systemName: "arrow.up.arrow.down")
        }
        static var up: some View {
            Image(systemName: "arrow.up")
        }
    }

    enum IconSize {
        static let thumbnail = CGSize(width: 28, height: 28)
        static let thumbnailOutside = CGSize(width: 32, height: 32)
        static let ll = CGSize(width: 40, height: 40)
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
