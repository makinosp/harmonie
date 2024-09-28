//
//  FriendPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/07.
//

import VRCKit

final actor FriendPreviewService: APIService, FriendServiceProtocol {
    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func fetchFriends(offset: Int, n: Int, offline: Bool) async throws -> [Friend] {
        offline ? PreviewDataProvider.shared.offlineFriends : PreviewDataProvider.shared.onlineFriends
    }

    func fetchFriends(count: Int, offline: Bool) async throws -> [Friend] {
        offline ? PreviewDataProvider.shared.offlineFriends : PreviewDataProvider.shared.onlineFriends
    }

    func unfriend(id: String) async throws {}
}
