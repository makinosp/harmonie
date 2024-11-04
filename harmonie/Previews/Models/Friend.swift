//
//  Friend.swift
//  Harmonie
//
//  Created by makinosp on 2024/10/21.
//

import Foundation
import VRCKit

extension PreviewData {
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

extension PreviewData.FriendSet {
    /// Initialize from world information
    init(
        id: UUID = UUID(),
        profile: PreviewData.Profile? = PreviewData.Profile.random,
        world: World,
        status: UserStatus
    ) {
        let location: Location = .id(PreviewData.instanceId(world))
        self.init(
            friend: Friend(
                id: id,
                profile: profile,
                location: location,
                status: status
            ),
            userDetail: PreviewData.userDetail(
                id: id,
                profile: profile,
                location: location,
                state: status == .offline ? .offline : .active,
                status: status
            )
        )
    }
}

extension PreviewData.FriendSet {
    /// Initialize from world information
    init(
        id: UUID = UUID(),
        profile: PreviewData.Profile? = PreviewData.Profile.random,
        location: Location,
        status: UserStatus
    ) {
        self.init(
            friend: Friend(
                id: id,
                profile: profile,
                location: location,
                status: status
            ),
            userDetail: PreviewData.userDetail(
                id: id,
                profile: profile,
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
        profile: PreviewData.Profile? = PreviewData.Profile.random,
        avatarImageUrl: URL? = PreviewData.iconImageUrl,
        location: Location,
        status: UserStatus
    ) {
        self.init(
            bio: "Biography",
            bioLinks: SafeDecodingArray(),
            avatarImageUrl: profile?.imageUrl(),
            avatarThumbnailUrl: profile?.imageUrl(),
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
