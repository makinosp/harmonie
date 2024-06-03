//
//  FriendListType.swift
//  harmonie
//
//  Created by makinosp on 2024/03/10.
//

import SwiftUI
import VRCKit

/// Defining friend list types and icons
enum FriendListType: CaseIterable, Identifiable {
    case all
    case active
    case joinMe
    case askMe
    case busy
    case offline
    case recently

    var id: Int {
        hashValue
    }

    var description: String {
        switch self {
            case .all:
                return "All Online"
            case .active:
                return "Active"
            case .joinMe:
                return "Join Me"
            case .askMe:
                return "Ask Me"
            case .busy:
                return "Do Not Disturb"
            case .offline:
                return "Offline"
            case .recently:
                return "Recently"
        }
    }

    var status: Status? {
        switch self {
            case .active:
                return .active
            case .joinMe:
                return .joinMe
            case .askMe:
                return .askMe
            case .busy:
                return .busy
            default:
                return nil
        }
    }

    @ViewBuilder
    var icon: some View {
        switch self {
            case .all:
                Image(systemName: "person.crop.rectangle.stack.fill")
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
            case .recently:
                Image(systemName: "person.crop.circle.badge.clock.fill")
        }
    }
}
