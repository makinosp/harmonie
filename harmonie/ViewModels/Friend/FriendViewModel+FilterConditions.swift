//
//  FriendViewModel+FilterConditions.swift
//  Harmonie
//
//  Created by makinosp on 2024/09/16.
//

import VRCKit

extension FriendViewModel {
    enum FilterUserStatus: Hashable, Identifiable {
        case all, status(UserStatus)
        var id: Int { hashValue }
    }

    enum FilterFavoriteGroups: Hashable, Identifiable {
        case all, favoriteGroup(FavoriteGroup)
        var id: Int { hashValue }
    }

    enum SortType: String, Hashable, Identifiable, CaseIterable {
        case `default`, displayName, lastLogin, status
        var id: Int { hashValue }
    }
}

extension FriendViewModel.FilterUserStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .all:
            "All"
        case .status(let status):
            status.description
        }
    }
}

extension FriendViewModel.FilterUserStatus: CaseIterable {
    static var allCases: [FriendViewModel.FilterUserStatus] {
        [
            .all,
            .status(.active),
            .status(.joinMe),
            .status(.askMe),
            .status(.busy),
            .status(.offline)
        ]
    }
}

extension FriendViewModel.SortType: CustomStringConvertible {
    var description: String {
        switch self {
        case .displayName: "Name"
        case .lastLogin: "Last Login"
        default: rawValue.localizedCapitalized
        }
    }
}
