//
//  StatusColor.swift
//  harmonie
//
//  Created by makinosp on 2024/04/07.
//

import SwiftUI
import VRCKit

class StatusColor {
    static func statusColor(_ status: User.Status) -> Color {
        switch status {
            case .joinMe:
                return .green
            case .active:
                return .cyan
            case .askMe:
                return .orange
            case .busy:
                return .red
            case .offline:
                return .gray
        }
    }
}
