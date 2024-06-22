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
    var client: APIClient
    var userData: UserData

    init(client: APIClient, userData: UserData) {
        self.client = client
        self.userData = userData
    }

    /// Fetch friends from API
    func fetchAllFriends() async throws {
        guard let user = userData.user else {
            throw HarmonieError.dataError
        }
        async let onlineFriendsTask = FriendService.fetchFriends(
            client,
            count: user.onlineFriends.count,
            offline: false
        )
        async let offlineFriendsTask = FriendService.fetchFriends(
            client,
            count: user.offlineFriends.count,
            offline: true
        )
        onlineFriends = try await onlineFriendsTask
        offlineFriends = try await offlineFriendsTask
    }
}
