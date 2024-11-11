//
//  FriendViewModel+Filters.swift
//  Harmonie
//
//  Created by makinosp on 2024/08/12.
//

import VRCKit

extension FriendViewModel {
    func clearFilters() {
        filterUserStatus = []
        filterFavoriteGroups = []
        applyFilters()
    }

    /// Filters the list of friends based on the specified list type.
    private var filteredFriends: [Friend] {
        recentlyFriends
            .filter { friend in
                filterFavoriteGroups.isEmpty ||
                isFriendContainedInFilterFavoriteGroups(friend: friend)
            }
            .filter {
                filterUserStatus.isEmpty || filterUserStatus.contains($0.status)
            }
            .filter {
                filterText.isEmpty || $0.displayName.range(of: filterText, options: .caseInsensitive) != nil
            }
            .sorted {
                switch sortType {
                case .latest: false
                case .oldest: true
                case .name: $0.displayName < $1.displayName
                case .loginLatest: $0.lastLogin > $1.lastLogin
                case .loginOldest: $0.lastLogin < $1.lastLogin
                case .status: $0.status.rawValue < $1.status.rawValue
                }
            }
    }

    func applyFilters() {
        isProcessingFilter = true
        Task {
            defer { isProcessingFilter = false }
            filterResultFriends = filteredFriends
        }
    }

    var isEmptyAllFilters: Bool {
        [ filterUserStatus.isEmpty, filterFavoriteGroups.isEmpty, filterText.isEmpty ].allSatisfy(\.self)
    }

    private func isFriendContainedInFilterFavoriteGroups(friend: Friend) -> Bool {
        filterFavoriteGroups.contains { favoriteGroup in
            guard let favoriteFriend = favoriteFriends.first(where: { favoriteFriend in
                favoriteFriend.favoriteGroupId == favoriteGroup.id
            }) else {
                return true
            }
            return favoriteFriend.friends.contains(friend)
        }
    }
}
