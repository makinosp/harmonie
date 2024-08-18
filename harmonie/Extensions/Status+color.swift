//
//  Status+color.swift
//  Harmonie
//
//  Created by makinosp on 2024/04/07.
//

import SwiftUI
import VRCKit

extension UserStatus {
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
