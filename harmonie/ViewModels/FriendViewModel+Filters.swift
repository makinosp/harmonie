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

    enum SortType: String, Hashable, Identifiable, CaseIterable {
        case `default`, displayName, lastLogin, status
        var id: Int { hashValue }
    }

    enum SortOrder {
        case asc, desc
    }

    /// Filters the list of friends based on the specified list type.
    /// - Parameter favoriteFriends: Favorite friends information.
    /// - Returns: A filtered list of friends whose display names meet the criteria defined by `isIncluded`.
    func filterFriends(favoriteFriends: [FavoriteFriend]) -> [Friend] {
        recentlyFriends
            .filter { friend in
                filterFavoriteGroups.isEmpty || filterFavoriteGroups.contains { favoriteGroup in
                    let predicate: ((FavoriteFriend) -> Bool) = { $0.favoriteGroupId == favoriteGroup.id }
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
            .sorted {
                switch (sortType, sortOrder) {
                case (.default, .asc): false
                case (.default, .desc): true
                case (.displayName, .asc): $0.displayName < $1.displayName
                case (.displayName, .desc): $0.displayName > $1.displayName
                case (.lastLogin, .asc): $0.lastLogin < $1.lastLogin
                case (.lastLogin, .desc): $0.lastLogin > $1.lastLogin
                case (.status, .asc): $0.status.rawValue < $1.status.rawValue
                case (.status, .desc): $0.status.rawValue > $1.status.rawValue
                }
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

extension FriendViewModel.SortOrder {
    mutating func toggle() {
        switch self {
        case .asc:
            self = .desc
        case .desc:
            self = .asc
        }
    }
}
