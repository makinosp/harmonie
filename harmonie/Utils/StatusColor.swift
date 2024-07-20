//
//  StatusColor.swift
//  Harmonie
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

    static func statusIcon(status: User.Status) -> some View {
        switch status {
        case .active:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.green)
        case .joinMe:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.cyan)
        case .askMe:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.orange)
        case .busy:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.red)
        case .offline:
            Image(systemName: "person.crop.circle.fill")
                .foregroundStyle(Color.gray)
        }
    }
}
