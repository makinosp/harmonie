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
    var isFetchingAllFriends = true
    var isProcessingFilter = false
    @ObservationIgnored private var appVM: AppViewModel?
    @ObservationIgnored var favoriteFriends: [FavoriteFriend] = []

    func setAppVM(_ appVM: AppViewModel) {
        self.appVM = appVM
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
        guard let appVM = appVM, let user = appVM.user else { return [] }
        return user.friends.reversed().compactMap { id in
            onlineFriends.first { $0.id == id } ?? offlineFriends.first { $0.id == id }
        }
    }

    var visibleFriendsLocations: [FriendsLocation] {
        friendsLocations.filter(\.location.isVisible)
    }

    /// Fetch friends from API
    func fetchAllFriends(errorHandler: @escaping (_ error: any Error) -> Void) async {
        defer { isFetchingAllFriends = false }
        isFetchingAllFriends = true
        guard let appVM = appVM else {
            errorHandler(ApplicationError.appVMIsNotSetError)
            return
        }
        do {
            guard let user = appVM.user else { throw ApplicationError.UserIsNotSetError }
            async let onlineFriendsTask = appVM.services.friendService.fetchFriends(
                count: user.onlineFriends.count + user.activeFriends.count,
                offline: false
            )
            async let offlineFriendsTask = appVM.services.friendService.fetchFriends(
                count: user.offlineFriends.count,
                offline: true
            )
            onlineFriends = try await onlineFriendsTask
            offlineFriends = try await offlineFriendsTask
        } catch {
            errorHandler(error)
            return
        }
        friendsLocations = await appVM.services.friendService.friendsGroupedByLocation(onlineFriends)
        applyFilters()
    }

    var isContentUnavailable: Bool {
        friendsLocations.isEmpty && !isFetchingAllFriends
    }
}

extension FriendViewModel {
    convenience init(appVM: AppViewModel) {
        self.init()
        setAppVM(appVM)
    }
}
