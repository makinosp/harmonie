//
//  Status+ColorRepresentable.swift
//  Harmonie
//
//  Created by makinosp on 2024/04/07.
//

import SwiftUICore
import VRCKit

extension UserStatus: ColorRepresentable {
    var color: Color {
        switch self {
        case .joinMe: .cyan
        case .active: .green
        case .askMe: .orange
        case .busy: .red
        case .offline: .gray
        }
    }
}
