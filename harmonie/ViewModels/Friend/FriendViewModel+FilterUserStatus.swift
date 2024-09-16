//
//  FriendViewModel+FilterUserStatus.swift
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
