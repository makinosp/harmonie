//
//  MainTabViewSegment.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/12.
//

import Foundation

enum MainTabViewSegment: String, CaseIterable {
    case social, friends, favorites, settings
}

extension MainTabViewSegment: CustomStringConvertible {
    var localizedString: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: rawValue.capitalized)
    }

    var description: String {
        String(localized: localizedString)
    }
}

extension MainTabViewSegment: Identifiable {
    var id: String { rawValue }
}

extension MainTabViewSegment {
    var icon: Iconizable {
        switch self {
        case .social: IconSet.social
        case .friends: IconSet.friends
        case .favorites: IconSet.favorite
        case .settings: IconSet.setting
        }
    }
}
