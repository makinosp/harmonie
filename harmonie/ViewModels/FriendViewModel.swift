//
//  FriendViewModel.swift
//  Harmonie
//
//  Created by makinosp on 2024/06/09.
//

import Foundation
import Observation
import VRCKit

@Observable @MainActor
final class FriendViewModel {
    var onlineFriends: [Friend] = []
    var offlineFriends: [Friend] = []
    var filterResultFriends: [Friend] = []
    var friendsLocations: [FriendsLocation] = []
    var filterUserStatus: Set<UserStatus> = []
    var filterFavoriteGroups: Set<FavoriteGroup.ID> = []
    var filterText: String = ""
    var sortType: SortType = .latest
    var isFetchingAllFriends = true
    var isProcessingFilter = false
    @ObservationIgnored private var appVM: AppViewModel?
    @ObservationIgnored var favoriteFriends: [FavoriteFriend] = []

    init() {
        restoreFilter()
    }

    func restoreFilter() {
        if let filterUserStatus = UserDefaults.standard.array(forKey: "filterUserStatus") as? [String] {
            let stored = filterUserStatus.map({ UserStatus(rawValue: $0)}).compactMap(\.self)
            self.filterUserStatus = Set(stored)
        }
        if let filterFavoriteGroups = UserDefaults.standard.array(forKey: "filterFavoriteGroups") as? [FavoriteGroup.ID] {
            self.filterFavoriteGroups = Set(filterFavoriteGroups)
        }
        if let sortType = UserDefaults.standard.string(forKey: "sortType"), let unwrapped = SortType(rawValue: sortType) {
            self.sortType = unwrapped
        }
    }

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

    /// Fetches all friends and updates the relevant data properties.
    ///
    /// This function asynchronously retrieves online and offline friends
    /// using the `FriendService`, updates their locations, and applies filters
    /// to the retrieved data. If an error occurs during any part of the process,
    /// the provided error handler is invoked. The function manages a loading state
    /// using the `isFetchingAllFriends` property.
    /// - Parameters errorHandler: A closure that is called with an error if one occurs
    ///              during the fetch operation.
    func fetchAllFriends(errorHandler: @escaping (_ error: any Error) -> Void) async {
        defer { isFetchingAllFriends = false }
        isFetchingAllFriends = true
        guard let appVM = appVM else {
            errorHandler(ApplicationError.appVMIsNotSetError)
            return
        }
        do {
            guard let user = appVM.user else { throw ApplicationError.userIsNotSetError }
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
