//
//  FriendPreviewService.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/07.
//

import MemberwiseInit
import VRCKit

@MemberwiseInit
final actor FriendPreviewService: APIService, FriendServiceProtocol {
    let client: APIClient

    func fetchFriends(offset: Int, n: Int, offline: Bool) async throws -> [Friend] {
        offline ? PreviewData.shared.offlineFriends : PreviewData.shared.onlineFriends
    }

    func fetchFriends(count: Int, offline: Bool) async throws -> [Friend] {
        offline ? PreviewData.shared.offlineFriends : PreviewData.shared.onlineFriends
    }

    func unfriend(id: String) async throws {}
}
