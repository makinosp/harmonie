//
//  FriendViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/09.
//

import Observation
import VRCKit

@Observable @MainActor
final class FriendViewModel {
    var onlineFriends: [Friend] = []
    var offlineFriends: [Friend] = []
    var filterResultFriends: [Friend] = []
    var friendsLocations: [FriendsLocation] = []
    var filterUserStatus: Set<UserStatus> = []
    var filterFavoriteGroups: Set<FavoriteGroup> = []
    var filterText: String = ""
    var sortType: SortType = .default
    var sortOrder: SortOrder = .asc
    var isRequesting = true
    var isProcessingFilter = false
    @ObservationIgnored let user: User
    @ObservationIgnored var favoriteFriends: [FavoriteFriend] = []

    init(user: User) {
        self.user = user
    }

    var allFriends: [Friend] {
        onlineFriends + offlineFriends
    }

    var friendsInPrivate: [Friend] {
        friendsLocations.first(where: { $0.location == .private })?.friends ?? []
    }

    func getFriend(id: String) -> Friend? {
        allFriends.first { $0.id == id }
    }

    /// Returns a list of matches for either `onlineFriends` or `offlineFriends`
    /// for each id of reversed order friend list.
    /// - Returns a list of recentry friends
    var recentlyFriends: [Friend] {
        user.friends.reversed().compactMap { id in
            onlineFriends.first { $0.id == id } ?? offlineFriends.first { $0.id == id }
        }
    }

    /// Fetch friends from API
    func fetchAllFriends<T: FriendServiceProtocol>(service: T) async throws where T: Sendable {
        async let onlineFriendsTask = service.fetchFriends(
            count: user.onlineFriends.count + user.activeFriends.count,
            offline: false
        )
        async let offlineFriendsTask = service.fetchFriends(
            count: user.offlineFriends.count,
            offline: true
        )
        onlineFriends = try await onlineFriendsTask
        offlineFriends = try await offlineFriendsTask
        friendsLocations = await service.friendsGroupedByLocation(onlineFriends)
        applyFilters()
    }
}
