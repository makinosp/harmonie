//
//  SegmentModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/21.
//

import SwiftUI

enum Segment {
    case friend, world
}

extension Segment: Identifiable {
    var id: Int { hashValue }
}

extension Segment: CaseIterable {
    var allCases: [Segment] {
        [.friend, .world]
    }
}

extension Segment: CustomStringConvertible {
    var description: String {
        switch self {
        case .friend: "Friend"
        case .world: "World"
        }
    }
}

extension Segment {
    @ViewBuilder var icon: some View {
        switch self {
        case .friend: Constants.IconSet.friends.icon
        case .world: Constants.IconSet.world.icon
        }
    }
}
