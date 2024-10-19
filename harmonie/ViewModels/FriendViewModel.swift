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
    var sortType: SortType = .latest
    var isRequesting = true
    var isProcessingFilter = false
    @ObservationIgnored let appVM: AppViewModel
    @ObservationIgnored var favoriteFriends: [FavoriteFriend] = []
    @ObservationIgnored lazy var friendService = lazyFriendService

    init(appVM: AppViewModel) {
        self.appVM = appVM
    }

    private var lazyFriendService: FriendServiceProtocol {
        appVM.isPreviewMode
        ? FriendPreviewService(client: appVM.client)
        : FriendService(client: appVM.client)
    }

    var allFriends: [Friend] {
        onlineFriends + offlineFriends
    }

    var friendsInPrivate: [Friend] {
        friendsLocations.first(where: { $0.location == .private })?.friends ?? []
    }

    func getFriend(id: Friend.ID) -> Friend? {
        allFriends.first { $0.id == id }
    }

    /// Returns a list of matches for either `onlineFriends` or `offlineFriends`
    /// for each id of reversed order friend list.
    /// - Returns a list of recentry friends
    var recentlyFriends: [Friend] {
        guard let user = appVM.user else { return [] }
        return user.friends.reversed().compactMap { id in
            onlineFriends.first { $0.id == id } ?? offlineFriends.first { $0.id == id }
        }
    }

    /// Fetch friends from API
    func fetchAllFriends() async throws {
        guard let user = appVM.user else { throw ApplicationError.UserIsNotSetError }
        async let onlineFriendsTask = friendService.fetchFriends(
            count: user.onlineFriends.count + user.activeFriends.count,
            offline: false
        )
        async let offlineFriendsTask = friendService.fetchFriends(
            count: user.offlineFriends.count,
            offline: true
        )
        onlineFriends = try await onlineFriendsTask
        offlineFriends = try await offlineFriendsTask
        friendsLocations = await friendService.friendsGroupedByLocation(onlineFriends)
        applyFilters()
    }
}
