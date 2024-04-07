//
//  StatusColor.swift
//  friendplus
//
//  Created by makinosp on 2024/04/07.
//

import SwiftUI
import VRCKit

class StatusColor {
    static func statusColor(_ statusString: String) -> Color {
        let status = FriendService.Status(rawValue: statusString)
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
            case .none:
                return .black
        }
    }
}
