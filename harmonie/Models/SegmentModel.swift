//
//  SegmentModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/21.
//

import SwiftUI

enum FavoriteViewSegment: String, CaseIterable {
    case friends, world
}

extension FavoriteViewSegment: Identifiable {
    var id: Int { hashValue }
}

extension FavoriteViewSegment: CustomStringConvertible {
    var localizedString: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: rawValue.capitalized)
    }

    var description: String {
        String(localized: localizedString)
    }
}

extension FavoriteViewSegment {
    var icon: Iconizable {
        switch self {
        case .friends: IconSet.friends
        case .world: IconSet.world
        }
    }
}
