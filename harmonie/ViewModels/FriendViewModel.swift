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
}
