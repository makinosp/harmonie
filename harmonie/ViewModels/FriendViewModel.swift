//
//  FriendViewModel.swift
//  harmonie
//
//  Created by makinosp on 2024/06/09.
//

import Foundation
import VRCKit

@MainActor
class FriendViewModel: ObservableObject {
    @Published var onlineFriends: [Friend] = []
    @Published var offlineFriends: [Friend] = []
    var appVM: AppViewModel

    init(appVM: AppViewModel) {
        self.appVM = appVM
    }

    /// Fetch friends from API
    func fetchAllFriends() async throws {
        guard let user = appVM.user else {
            throw Errors.dataError
        }
        async let onlineFriendsTask = FriendService.fetchFriends(
            appVM.client,
            count: user.onlineFriends.count,
            offline: false
        )
        async let offlineFriendsTask = FriendService.fetchFriends(
            appVM.client,
            count: user.offlineFriends.count,
            offline: true
        )
        onlineFriends = try await onlineFriendsTask
        offlineFriends = try await offlineFriendsTask
    }

    /// Filters the list of friends based on the specified list type.
    /// - Parameter listType: The type of friend list to filter.
    /// - Returns: A filtered list of friends whose display names meet the criteria defined by `isIncluded`.
    func filterFriends(by listType: FriendsView.FriendListType, searchString: String) -> [Friend] {
        let friends: [Friend]
        switch listType {
        case .all:
            friends = onlineFriends
        case .recently:
            friends = recentlyFriends
        case .status(let status) where status == .offline:
            friends = offlineFriends
        case .status(let status):
            friends = onlineFriends.filter { $0.status == status }
        }
        return friends.filter {
            searchString.isEmpty || $0.displayName.range(of: searchString, options: .caseInsensitive) != nil
        }
    }

    /// Returns a list of matches for either `onlineFriends` or `offlineFriends`
    /// for each id of reversed order friend list.
    /// - Returns a list of recentry friends
    var recentlyFriends: [Friend] {
        guard let ids = appVM.user?.friends else { return [] }
        return ids.reversed().compactMap { id in
            onlineFriends.first { $0.id == id } ?? offlineFriends.first { $0.id == id }
        }
    }
}
