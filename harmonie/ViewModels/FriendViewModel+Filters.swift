//
//  FriendViewModel+Filters.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import Foundation
import VRCKit

extension FriendViewModel {
    enum FriendListType: Hashable, Identifiable {
        case all, status(UserStatus)
        var id: Int { self.hashValue }
    }
    enum FilterFavoriteGroups: Hashable, Identifiable {
        case all, favoriteGroup(FavoriteGroup)
        var id: Int { hashValue }
    }

    /// Filters the list of friends based on the specified list type.
    /// - Parameter text: The text of friend list to filter.
    /// - Parameter statuses: The statuses of set of friend list to filter.
    /// - Parameter sort: The type of friend list to sort.
    /// - Returns: A filtered list of friends whose display names meet the criteria defined by `isIncluded`.
    func filterFriends(text: String, statuses: Set<UserStatus>, sort: FriendSortType = .default) -> [Friend] {
        recentlyFriends
            .filter {
                statuses.isEmpty || statuses.contains($0.status)
            }
            .filter {
                text.isEmpty || $0.displayName.range(of: text, options: .caseInsensitive) != nil
            }
    }

    /// Returns a list of matches for either `onlineFriends` or `offlineFriends`
    /// for each id of reversed order friend list.
    /// - Returns a list of recentry friends
    var recentlyFriends: [Friend] {
        user.friends.reversed().compactMap { id in
            onlineFriends.first { $0.id == id } ?? offlineFriends.first { $0.id == id }
        }
    }
}

extension FriendViewModel.FriendListType: CustomStringConvertible {
    var description: String {
        switch self {
        case .all:
            return "All"
        case .status(let status):
            return status.description
        }
    }
}

extension FriendViewModel.FriendListType: CaseIterable {
    static var allCases: [FriendViewModel.FriendListType] {
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
