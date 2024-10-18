//
//  SegmentModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/21.
//

import SwiftUI

enum FavoriteViewSegment: String {
    case all, friends, world
}

extension FavoriteViewSegment: Identifiable {
    var id: Int { hashValue }
}

extension FavoriteViewSegment: CaseIterable {
    var allCases: [Self] {
        [.all, .friends, .world]
    }
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
    @ViewBuilder var icon: some View {
        switch self {
        case .all: IconSet.favoriteSquares.icon
        case .friends: IconSet.friends.icon
        case .world: IconSet.world.icon
        }
    }
}
