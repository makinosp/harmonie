//
//  FriendViewModel+Filters.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import Foundation
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

    enum SortType: Hashable, Identifiable {
        case `default`
        var id: Int { hashValue }
    }

    /// Filters the list of friends based on the specified list type.
    /// - Parameter favoriteFriends: Favorite friends information.
    /// - Returns: A filtered list of friends whose display names meet the criteria defined by `isIncluded`.
    func filterFriends(favoriteFriends: [FavoriteViewModel.FavoriteFriend]) -> [Friend] {
        recentlyFriends
            .filter { friend in
                filterFavoriteGroups.isEmpty || filterFavoriteGroups.contains { favoriteGroup in
                    let predicate: ((FavoriteViewModel.FavoriteFriend) -> Bool) = { $0.favoriteGroupId == favoriteGroup.id }
                    guard let favoriteFriend = favoriteFriends.first(where: predicate) else { return true }
                    return favoriteFriend.friends.contains(friend)
                }
            }
            .filter {
                filterUserStatus.isEmpty || filterUserStatus.contains($0.status)
            }
            .filter {
                filterText.isEmpty || $0.displayName.range(of: filterText, options: .caseInsensitive) != nil
            }
    }

    func applyFilterUserStatus(_ listType: FilterUserStatus) {
        switch listType {
        case .all:
            filterUserStatus.removeAll()
        case .status(let status):
            if filterUserStatus.contains(status) {
                filterUserStatus.remove(status)
            } else {
                filterUserStatus.insert(status)
            }
        }
    }

    func applyFilterFavoriteGroup(_ type: FilterFavoriteGroups) {
        switch type {
        case .all:
            filterFavoriteGroups.removeAll()
        case .favoriteGroup(let favoriteGroup):
            if filterFavoriteGroups.contains(favoriteGroup) {
                filterFavoriteGroups.remove(favoriteGroup)
            } else {
                filterFavoriteGroups.insert(favoriteGroup)
            }
        }
    }

    func isCheckedFilterUserStatus(_ listType: FilterUserStatus) -> Bool {
        switch listType {
        case .all:
            filterUserStatus.isEmpty
        case .status(let status):
            filterUserStatus.contains(status)
        }
    }

    func isCheckedFilterFavoriteGroups(_ listType: FilterFavoriteGroups) -> Bool {
        switch listType {
        case .all:
            filterFavoriteGroups.isEmpty
        case .favoriteGroup(let favoriteGroup):
            filterFavoriteGroups.contains(favoriteGroup)
        }
    }
}

extension FriendViewModel.FilterUserStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .all:
            return "All"
        case .status(let status):
            return status.description
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
