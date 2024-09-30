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

    enum IconSet {
        static var check: some Iconizable {
            Icon("checkmark")
        }
        static var circleFilled: some Iconizable {
            Icon("circle.fill")
        }
        static var dots: some Iconizable {
            Icon("ellipsis.circle")
        }
        static var down: some Iconizable {
            Icon("arrow.down")
        }
        static var exclamation: some Iconizable {
            Icon("exclamationmark")
        }
        static var favorite: some Iconizable {
            Icon("star")
        }
        static var favoriteFilled: some Iconizable {
            Icon("star.fill")
        }
        static var filter: some Iconizable {
            Icon("line.3.horizontal.decrease")
        }
        static var forward: some Iconizable {
            Icon("chevron.forward")
        }
        static var friends: some Iconizable {
            Icon("person.2")
        }
        static var location: some Iconizable {
            Icon("location")
        }
        static var setting: some Iconizable {
            Icon("gear")
        }
        static var shield: some Iconizable {
            Icon("shield.fill")
        }
        static var sort: some Iconizable {
            Icon("arrow.up.arrow.down")
        }
        static var up: some Iconizable {
            Icon("arrow.up")
        }
        static var world: some Iconizable {
            Icon("globe.desk")
        }
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
