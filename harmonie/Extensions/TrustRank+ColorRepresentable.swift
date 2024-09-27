//
//  TrustRank+ColorRepresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/27.
//

import SwiftUI
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
