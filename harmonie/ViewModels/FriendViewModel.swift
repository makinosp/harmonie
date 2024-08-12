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
}
