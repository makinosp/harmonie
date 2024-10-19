//
//  TrustRank+ColorRepresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/27.
//

import SwiftUICore
import VRCKit

extension TrustRank: ColorRepresentable {
    var color: Color {
        switch self {
        case .trusted: .indigo
        case .known: .orange
        case .user: .green
        case .newUser: .blue
        case .visitor, .unknown: .gray
        }
    }
}
