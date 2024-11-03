//
//  Friend.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/21.
//

import Foundation
import VRCKit

extension PreviewDataProvider {
    struct FriendSet {
        let friend: Friend
        let userDetail: UserDetail
    }

    var onlineFriends: [Friend] {
        friends.filter { $0.status != .offline }
    }

    var offlineFriends: [Friend] {
        friends.filter { $0.status == .offline }
    }

    static var friend: Friend {
        Friend(id: UUID(), location: .offline, status: .offline)
    }
}

extension PreviewDataProvider.FriendSet {
    init(
        id: UUID,
        location: Location,
        status: UserStatus
    ) {
        self.init(
            friend: Friend(
                id: id,
                location: location,
                status: status
            ),
            userDetail: PreviewDataProvider.userDetail(
                id: id,
                location: location,
                state: status == .offline ? .offline : .active,
                status: status
            )
        )
    }
}

private extension Friend {
    init(
        id: UUID,
        avatarImageUrl: URL? = PreviewDataProvider.iconImageUrl,
        location: Location,
        status: UserStatus
    ) {
        let profile = PreviewProfile.random
        self.init(
            bio: "Biography",
            bioLinks: SafeDecodingArray(),
            avatarImageUrl: avatarImageUrl,
            avatarThumbnailUrl: avatarImageUrl,
            displayName: profile?.name ?? "",
            id: "usr_\(id.uuidString)",
            isFriend: true,
            lastLogin: Date(),
            lastPlatform: "standalonewindows",
            platform: .blank,
            profilePicOverride: nil,
            status: status,
            statusDescription: "",
            tags: UserTags(),
            userIcon: nil,
            location: location,
            friendKey: ""
        )
    }
}
