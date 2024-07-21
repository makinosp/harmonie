//
//  FriendViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/09.
//

import Foundation
import VRCKit

@MainActor
class FriendViewModel: ObservableObject {
    @Published var onlineFriends: [Friend] = []
    @Published var offlineFriends: [Friend] = []
    let user: User
    var service: any FriendServiceProtocol

    init(user: User, service: any FriendServiceProtocol) {
        self.user = user
        self.service = service
    }

    enum FriendListType: Hashable, Identifiable {
        case all, status(UserStatus)
        var id: Int { self.hashValue }
    }

    enum FriendSortType: Hashable, Identifiable {
        case `default`
        var id: Int { self.hashValue }
    }

    var allFriends: [Friend] {
        onlineFriends + offlineFriends
    }

    func getFriend(id: String) -> Friend? {
        allFriends.first { $0.id == id }
    }

    var friendsLocations: [FriendsLocation] {
        service.friendsGroupedByLocation(onlineFriends)
    }

    /// Fetch friends from API
    func fetchAllFriends() async throws {
        async let onlineFriendsTask = service.fetchFriends(
            count: user.onlineFriends.count,
            offline: false
        )
        async let offlineFriendsTask = service.fetchFriends(
            count: user.offlineFriends.count,
            offline: true
        )
        onlineFriends = try await onlineFriendsTask
        offlineFriends = try await offlineFriendsTask
    }

    /// Filters the list of friends based on the specified list type.
    /// - Parameter text: The text of friend list to filter.
    /// - Parameter statuses: The statuses of set of friend list to filter.
    /// - Parameter sort: The type of friend list to sort.
    /// - Returns: A filtered list of friends whose display names meet the criteria defined by `isIncluded`.
    func filterFriends(text: String, statuses: Set<UserStatus>, sort: FriendSortType = .default) -> [Friend] {
        recentlyFriends.filter {
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
