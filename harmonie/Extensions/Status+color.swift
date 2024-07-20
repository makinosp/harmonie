//
//  Status+color.swift
//  Harmonie
//
//  Created by makinosp on 2024/04/07.
//

import SwiftUI
import VRCKit

extension User.Status {
    var color: Color {
        switch self {
        case .joinMe:
            return .cyan
        case .active:
            return .green
        case .askMe:
            return .orange
        case .busy:
            return .red
        case .offline:
            return .gray
        }
    }
}
