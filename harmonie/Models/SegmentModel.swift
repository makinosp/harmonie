//
//  SegmentModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/21.
//

import SwiftUI

enum Segment: String {
    case friends, world
}

extension Segment: Identifiable {
    var id: Int { hashValue }
}

extension Segment: CaseIterable {
    var allCases: [Segment] {
        [.friends, .world]
    }
}

extension Segment: CustomStringConvertible {
    var localizedString: LocalizedStringResource {
        LocalizedStringResource(stringLiteral: rawValue.capitalized)
    }

    var description: String {
        String(localized: localizedString)
    }
}

extension Segment {
    @ViewBuilder var icon: some View {
        switch self {
        case .friends: IconSet.friends.icon
        case .world: IconSet.world.icon
        }
    }
}
