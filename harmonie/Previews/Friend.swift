//
//  Friend.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/21.
//

import Foundation
import VRCKit

extension PreviewDataProvider {
    typealias FriendSet = (friend: Friend, userDetail: UserDetail)

    var onlineFriends: [Friend] {
        friends.filter { $0.status != .offline }
    }

    var offlineFriends: [Friend] {
        friends.filter { $0.status == .offline }
    }

    static func friend(id: UUID, location: Location, status: UserStatus) -> Friend {
        Friend(id: id, location: location, status: status)
    }

    static var friend: Friend {
        Friend(id: UUID(), location: .offline, status: .offline)
    }

    static func friendSet(
        id: UUID,
        location: Location,
        status: UserStatus
    ) -> FriendSet {
        (
            Friend(
                id: id,
                location: location,
                status: status
            ),
            PreviewDataProvider.userDetail(
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
        displayName: String = PreviewString.Name.randomValue,
        location: Location,
        status: UserStatus
    ) {
        self.init(
            bio: "Biography",
            bioLinks: SafeDecodingArray(),
            avatarImageUrl: PreviewDataProvider.iconImageUrl,
            avatarThumbnailUrl: PreviewDataProvider.iconImageUrl,
            displayName: displayName,
            id: "usr_\(id.uuidString)",
            isFriend: true,
            lastLogin: Date(),
            lastPlatform: "standalonewindows",
            platform: .blank,
            profilePicOverride: PreviewDataProvider.iconImageUrl,
            status: status,
            statusDescription: "",
            tags: UserTags(),
            userIcon: PreviewDataProvider.iconImageUrl,
            location: location,
            friendKey: ""
        )
    }
}
