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

    init(client: APIClient) {
        self.client = client
    }

    /// Fetch friends from API
    func fetchAllFriends(count: Int) async throws {
        onlineFriends = try await FriendService.fetchFriends(
            client,
            count: count,
            offline: false
        )
    }
}
