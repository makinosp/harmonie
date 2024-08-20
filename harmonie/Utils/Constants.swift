//
//  Constants.swift
//  Harmonie
//
//  Created by makinosp on 2024/07/22.
//

import SwiftUI

enum Constants {
    enum Icon {
        static var forward: some View {
            Image(systemName: "chevron.forward")
                .foregroundStyle(Color(uiColor: .systemGray))
                .imageScale(.small)
        }
    }
    
    enum IconSize {
        static let thumbnail = CGSize(width: 28, height: 28)
        static let thumbnailOutside = CGSize(width: 32, height: 32)
        static let ll = CGSize(width: 40, height: 40)
    }

    enum IconName {
        static let check = "checkmark"
        static let circleFilled = "circle.fill"
        static let dots = "ellipsis.circle"
        static let exclamation = "exclamationmark.circle"
        static let loctaion = "location.fill"
        static let filter = "line.3.horizontal.decrease"
        static let favorite = "star"
        static let favoriteFilled = "star.fill"
        static let friends = "person.2.fill"
        static let setting = "gear"
    }
}
