//
//  Constants.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/22.
//

import Foundation

enum Constants {
    enum IconSize {
        static let thumbnail = CGSize(width: 28, height: 28)
        static let thumbnailOutside = CGSize(width: 32, height: 32)
        static let ll = CGSize(width: 40, height: 40)
    }

    enum Spacing {
        static let s: CGFloat = 4
        static let m: CGFloat = 8
        static let l: CGFloat = 12
        static let ll: CGFloat = 16
        static let xl: CGFloat = 32
    }

    enum IconName {
        static let check = "checkmark"
        static let circleFilled = "circle.fill"
        static let exclamation = "exclamationmark.circle"
        static let loctaion = "location.fill"
        static let filter = "line.3.horizontal.decrease"
        static let favorite = "star"
        static let favoriteFilled = "star.fill"
        static let friends = "person.2.fill"
        static let setting = "gear"
    }
}
